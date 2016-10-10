//
//  LSJHomeRankVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeRankVC.h"
#import "LSJRankCell.h"
#import "LSJColumnConfigModel.h"
#import "LSJRankDetailVC.h"

static NSString *const kRankCellReusableIdentifier = @"RankCellReusableIdentifier";

@interface LSJHomeRankVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) LSJColumnConfigModel *programModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableArray *widthSource;
@end

@implementation LSJHomeRankVC
QBDefineLazyPropertyInitialization(LSJColumnConfigModel, programModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, widthSource)

- (instancetype)initWithColumnId:(NSInteger)columnId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(30);
    mainLayout.minimumInteritemSpacing = kWidth(20);
    mainLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[LSJRankCell class] forCellWithReuseIdentifier:kRankCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView LSJ_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    [_layoutCollectionView LSJ_triggerPullToRefresh];
    [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
        @strongify(self);
        [self->_layoutCollectionView LSJ_endPullToRefresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self->_layoutCollectionView LSJ_triggerPullToRefresh];
        });
    }];
}

- (void)loadData {
    @weakify(self);
    [self.programModel fetchColumnsInfoWithColumnId:_columnId IsProgram:NO CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutCollectionView LSJ_endPullToRefresh];
        [self removeCurrentRefreshBtn];
        if (success) {
            [self.dataSource removeAllObjects];
            [self.widthSource removeAllObjects];
            for (LSJColumnModel *column in obj) {
                CGSize size = [column.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(30)]}];
                [self.widthSource addObject:@(size.width)];
                [self.dataSource addObject:column];
            }
            [_layoutCollectionView reloadData];
        }else {
            if (self.dataSource.count == 0) {
                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                    @strongify(self);
                    [self->_layoutCollectionView LSJ_triggerPullToRefresh];
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSJRankCell *rankCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRankCellReusableIdentifier forIndexPath:indexPath];
    LSJColumnModel *column = _dataSource[indexPath.item];
    if (indexPath.item < self.dataSource.count) {
        rankCell.imgUrl = column.columnImg;
        rankCell.titleStr = column.name;
        rankCell.rank = indexPath.item;
        rankCell.hotCount = [column.spare integerValue];
        rankCell.width = [self.widthSource[indexPath.item] floatValue];
        return rankCell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJColumnModel *column = self.dataSource[indexPath.item];
    LSJRankDetailVC *rankDetailVC = [[LSJRankDetailVC alloc] initWithColumnId:column.columnId];
    [self.navigationController pushViewController:rankDetailVC animated:YES];
    LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:nil ProgramType:nil RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:3];
    [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
    const CGFloat height = width * 444 / 345.;
    return CGSizeMake((long)width, (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(20), kWidth(20), kWidth(20));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:3 forSlideCount:1];
}
@end
