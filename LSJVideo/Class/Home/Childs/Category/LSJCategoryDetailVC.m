//
//  LSJCategoryDetailVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJCategoryDetailVC.h"
#import "LSJHomeProgramModel.h"
#import "LSJCategoryDetailCell.h"

static NSString *const kCategoryDetailsCellReusableIdentifier = @"categoryDetailCellReusableIdentifier";

@interface LSJCategoryDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _columnId;
    NSString *_colorHexStr;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) LSJHomeProgramModel *programModel;
@property (nonatomic) LSJColumnModel *response;

@end

@implementation LSJCategoryDetailVC
DefineLazyPropertyInitialization(LSJHomeProgramModel, programModel)
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
    [_layoutCollectionView registerClass:[LSJCategoryDetailCell class] forCellWithReuseIdentifier:kCategoryDetailsCellReusableIdentifier];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)loadData {
    [self.programModel fetchHomeInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        if (success) {
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
    LSJCategoryDetailCell *categoryDetailCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryDetailsCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.item];
        categoryDetailCell.titleStr = program.title;
        categoryDetailCell.imgUrlStr = program.coverImg;
        categoryDetailCell.tagHexStr = self.response.spare;
        categoryDetailCell.tagTitleStr = self.response.name;
        return categoryDetailCell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
    const CGFloat height = width * 0.6+kWidth(60);
    return CGSizeMake((long)width, (long)height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(10), kWidth(10), kWidth(10), kWidth(10));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //[[LTStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtils currentSubTabPageIndex] forSlideCount:1];
}

@end
