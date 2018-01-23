//
//  LSJHomeCategoryVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeCategoryVC.h"
#import "LSJColumnConfigModel.h"
#import "LSJCategoryCell.h"
#import "LSJCategoryDetailVC.h"

static NSString *const kCategoryCellReusableIdentifier = @"categoryCellReusableIdentifier";


@interface LSJHomeCategoryVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) LSJColumnConfigModel *programModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation LSJHomeCategoryVC
QBDefineLazyPropertyInitialization(LSJColumnConfigModel, programModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
    mainLayout.minimumLineSpacing = 5;
    mainLayout.minimumInteritemSpacing = 5;
    mainLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[LSJCategoryCell class] forCellWithReuseIdentifier:kCategoryCellReusableIdentifier];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutCollectionView LSJ_triggerPullToRefresh];
            }];
        }
    });
    
}

- (void)loadData {
    @weakify(self);
    [self.programModel fetchColumnsInfoWithColumnId:_columnId IsProgram:NO CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [_layoutCollectionView LSJ_endPullToRefresh];
        if (success) {
            [self removeCurrentRefreshBtn];
            [self.dataSource removeAllObjects];
            [_layoutCollectionView LSJ_endPullToRefresh];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView reloadData];
        }
//        else {
//            if (self.dataSource.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self->_layoutCollectionView LSJ_triggerPullToRefresh];
//                }];
//            }
//        }
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
    
    LSJCategoryCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellReusableIdentifier forIndexPath:indexPath];
    LSJColumnModel *column = _dataSource[indexPath.item];
    //    LSJProgramModel *program = column.programList[indexPath.item];
    if (indexPath.item < self.dataSource.count) {
        categoryCell.title = column.name;
        categoryCell.imgUrl = column.columnImg;
        categoryCell.colorHexStr = column.spare;
        return categoryCell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJColumnModel *column = _dataSource[indexPath.item];
    LSJCategoryDetailVC *cateDetailVC = [[LSJCategoryDetailVC alloc] initWithColumnId:column.columnId];
    [self.navigationController pushViewController:cateDetailVC animated:YES];
    LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:nil ProgramType:nil RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:2];
    [[LSJStatsManager sharedManager] statsCPCWithBaseModel: baseModel inTabIndex:self.tabBarController.selectedIndex];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
    const CGFloat height = width * 458 / 353.;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:2 forSlideCount:1];
}

@end
