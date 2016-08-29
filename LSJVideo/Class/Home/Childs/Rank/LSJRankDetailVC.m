//
//  LSJRankDetailVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJRankDetailVC.h"
#import "LSJProgramConfigModel.h"
#import "LSJRankDetailCell.h"
#import "LSJColumnModel.h"

static NSString *const kRankDetailCellReusableIdentifier = @"RankDetailCellReusableIdentifier";

@interface LSJRankDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) LSJProgramConfigModel *programModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJColumnModel *response;
@end

@implementation LSJRankDetailVC
DefineLazyPropertyInitialization(LSJProgramConfigModel, programModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(LSJColumnModel, response)

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
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = 0;
    mainLayout.minimumInteritemSpacing = kWidth(10);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[LSJRankDetailCell class] forCellWithReuseIdentifier:kRankDetailCellReusableIdentifier];
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
}

- (void)loadData {
    [self.programModel fetchProgramsInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        if (success) {
            [self.dataSource removeAllObjects];
            [_layoutCollectionView LSJ_endPullToRefresh];
            self.response = obj;
            self.title = self.response.name;
            [_layoutCollectionView reloadData];
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
    return self.response.programList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJRankDetailCell *rankDetailCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRankDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.item];
        rankDetailCell.imgUrlStr = program.coverImg;
        rankDetailCell.titleStr = program.title;
        return rankDetailCell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.item];
        [self pushToDetailVideoWithController:self programId:program.programId];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat width = (fullWidth - layout.minimumInteritemSpacing * 2 - insets.left - insets.right)/3;
    const CGFloat height = width * 9 / 7.+kWidth(60);
    return CGSizeMake((long)width, (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(10), kWidth(10), kWidth(10), kWidth(10));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //[[LTStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtils currentSubTabPageIndex] forSlideCount:1];
}

@end
