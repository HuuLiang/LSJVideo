//
//  LSJHomeRecommdVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeRecommdVC.h"

#import "LSJHomeSectionHeaderView.h"
#import "LSJRecommdCell.h"

#import "LSJHomeProgramModel.h"

#import <SDCycleScrollView.h>

static NSString *const kRecommendCellReusableIdentifier = @"RecommendCellReusableIdentifier";
static NSString *const kHomeBigCellReusableIdentifier = @"HomeBigCellReusableIdentifier";

static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kFreeCellReusableIdentifier = @"FreeCellReusableIdentifier";
static NSString *const kHomeSectionHeaderReusableIdentifier = @"HomeSectionHeaderReusableIdentifier";

@interface LSJHomeRecommdVC () <UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
    UICollectionView *_freeCollectionView;
    UICollectionViewCell *_freeCell;
    UICollectionViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;

}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJHomeProgramModel *programModel;
@end

@implementation LSJHomeRecommdVC
DefineLazyPropertyInitialization(LSJHomeProgramModel, programModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
    self.view.backgroundColor = [UIColor cyanColor];
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *freeLayout = [[UICollectionViewFlowLayout alloc] init];
    freeLayout.minimumLineSpacing = 5;
    freeLayout.minimumInteritemSpacing = 5;
    _freeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:freeLayout];
    _freeCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _freeCollectionView.delegate = self;
    _freeCollectionView.dataSource = self;
    _freeCollectionView.showsVerticalScrollIndicator = NO;
    
    
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = 5;
    mainLayout.minimumInteritemSpacing = 5;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[LSJRecommdCell class] forCellWithReuseIdentifier:kRecommendCellReusableIdentifier];
//    [_layoutCollectionView registerClass:[LTHomeBigCell class] forCellWithReuseIdentifier:kHomeBigCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kFreeCellReusableIdentifier];
    [_layoutCollectionView registerClass:[LSJHomeSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeSectionHeaderReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView LSJ_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadChannels];
    }];
    [_layoutCollectionView LSJ_triggerPullToRefresh];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadChannels {
    [self.programModel fetchHomeInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutCollectionView LSJ_endPullToRefresh];
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (LSJHomeProgramListModel *column in self.dataSource) {
        if (column.type == 4) {
            for (LSJProgramModel *program in column.programList) {
                [imageUrlGroup addObject:program.coverImg];
                [titlesGroup addObject:program.title];
            }
            _bannerView.imageURLStringsGroup = imageUrlGroup;
            _bannerView.titlesGroup = titlesGroup;
        }
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//        NSInteger count = 0;
//        for (LSJHomeProgramListModel * column in self.dataSource) {
//            if (column.type == 1 || column.type == 4) {
//                count++;
//            } else if (column.type == 3) {
//                if ([LSJUtil isVip]) {
//                    count++;
//                }
//            } else if (column.type == 5) {
//                if (![LSJUtil isVip]) {
//                    count++;
//                }
//            }
//        }
//        return count;
//    } else if (collectionView == _freeCollectionView) {
//        return 1;
//    } else {
//        return 0;
//    }
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    LSJHomeProgramListModel *model = self.dataSource[section];
//    if (model.type == 4) {
//        return 1;
//    } else if (model.type == 1){
//        return model.programList.count;
//    } else if (model.type == 3) {
//        if ([LSJUtil isVip]) {
//            return 1;
//        } else {
//            return 0;
//        }
//    } else if (model.type == 5) {
//        if ([LSJUtil isVip]) {
//            return 0;
//        } else {
//            return model.programList.count;
//        }
//    } else {
//        return 0;
//    }
    if (model.type == 4 || model.type == 3 || model.type == 5) {
        return 1;
    } else if (model.type == 1) {
        return model.programList.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJRecommdCell *recommendCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCellReusableIdentifier forIndexPath:indexPath];
    //    LTHomeBigCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBigCellReusableIdentifier forIndexPath:indexPath];
    LSJHomeProgramListModel *column = _dataSource[indexPath.section];
    LSJProgramModel *program = column.programList[indexPath.item];
    if (collectionView == _layoutCollectionView) {
        if (column.type == 4) {
            if (!_bannerCell) {
                _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
                [_bannerCell.contentView addSubview:_bannerView];
                {
                    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(_bannerCell.contentView);
                    }];
                }
            }
            return _bannerCell;
        } else if (column.type == 5) {
            if (!_freeCell) {
                _freeCell = [collectionView dequeueReusableCellWithReuseIdentifier:kFreeCellReusableIdentifier forIndexPath:indexPath];
                [_freeCell.contentView addSubview:_freeCollectionView];
                {
                    [_freeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(_freeCell.contentView);
                    }];
                }
            }
            return _freeCell;
        } else {
            recommendCell.title = program.title;
            recommendCell.imgUrl = program.coverImg;
            return recommendCell;
        }
    } else if (collectionView == _freeCollectionView) {
        recommendCell.title = program.title;
        recommendCell.imgUrl = program.coverImg;
        return recommendCell;
    } else {
        return nil;
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LSJHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
    LSJHomeProgramListModel *column = _dataSource[indexPath.section];
    headerView.titleStr = column.name;
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    LTColumnModel *column = _dataSource[indexPath.section];
//    LTProgramModel *program = column.programList[indexPath.item];
//    LTDetailController *detailVC = [[LTDetailController alloc] initWithColumnId:[NSString stringWithFormat:@"%lu",column.columnId] ProgramId:[NSString stringWithFormat:@"%lu",program.programId] type:[NSString stringWithFormat:@"%ld",column.type]];
//    detailVC.channel = (LTChannel *)column;
//    detailVC.programType = program.type;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    
//    [[LTStatsManager sharedManager] statsCPCWithProgram:(LTProgram *)program programLocation:indexPath.item inChannel:(LTChannel *)column andTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtils currentSubTabPageIndex]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
//    if (indexPath.section == 0 && indexPath.item == 0) {
//        return CGSizeMake(fullWidth, fullWidth/2);
//    } else if (indexPath.section == 1) {
//        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
//        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
//        const CGFloat width = (fullWidth - layout.minimumInteritemSpacing - insets.left - insets.right)/2;
//        const CGFloat height = [LTHomeCell heightRelativeToWidth:width landscape:YES];
//        return CGSizeMake(width, height);
//    } else {
//        return CGSizeMake(fullWidth-20, (fullWidth-20)/2);
//    }
//    return CGSizeZero;
    LSJHomeProgramListModel *column = _dataSource[indexPath.section];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat width;
    CGFloat height;
    
    if (column.type == 4 || (column.type == 3 && [LSJUtil isVip])) {
        return CGSizeMake(fullWidth, fullWidth/2.);
    } else if (column.type == 1 && column.showMode == 1) {
        if (indexPath.item == 0) {
            width = fullWidth - insets.left - insets.right;
            height = width / 3 + kWidth(30);
            return CGSizeMake(width, height);
        } else {
            width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
            height = width * 0.6 + kWidth(30);
            return CGSizeMake(width, height);
        }
    } else if (column.type == 1 && column.showMode == 2) {
        width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        height = width * 9 / 7 + kWidth(30);
        return CGSizeMake(width, height);
    } else if (column.type == 5 && ![LSJUtil isVip]) {
        width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 2.5;
        height = width * 9 /7 + kWidth(30);
        return CGSizeMake(width, height);8
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    LSJHomeProgramListModel *column = _dataSource[section];
    if (column.type == 4) {
        return UIEdgeInsetsMake(0, 0, 5, 0);
    } else if (column.type == 1 || (column.type == 3 && [LSJUtil isVip]) || (column.type == 5 && ![LSJUtil isVip])) {
        return UIEdgeInsetsMake(5, 10, 3, 10);
    } else {
        return UIEdgeInsetsZero;
    }
    
//    return section == 0 ? UIEdgeInsetsMake(0,0,5,0) : UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    LSJHomeProgramListModel *column = _dataSource[section];
//    if (column.type == 4) {
//        return CGSizeZero;
//    } else if (column.type == 5) {
//        if ([LSJUtil isVip]) {
//            return CGSizeZero;
//        } else {
//            UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
//            return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
//        }
//    } else if (column.type == 3) {
//        if ([LSJUtil isVip]) {
//            UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
//            return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
//        } else {
//            return CGSizeZero;
//        }
//    } else {
//        return CGSizeZero;
//    }
    
    if ((column.type == 5 && ![LSJUtil isVip]) || (column.type == 3 && [LSJUtil isVip]) || column.type == 1) {
        UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
        return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, 30);
    } else {
        return CGSizeZero;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    for (LTColumnModel *column in _dataSource) {
//        if (column.type == 4) {
//            LTProgramModel *program = column.programList[index];
//            LTDetailController *detailVC = [[LTDetailController alloc] initWithColumnId:[NSString stringWithFormat:@"%lu",column.columnId] ProgramId:[NSString stringWithFormat:@"%lu",program.programId] type:[NSString stringWithFormat:@"%ld",column.type]];
//            detailVC.channel = (LTChannel *)column;
//            detailVC.programType = program.type;
//            [self.navigationController pushViewController:detailVC animated:YES];
//            [[LTStatsManager sharedManager] statsCPCWithProgram:(LTProgram *)program programLocation:index inChannel:(LTChannel*)column andTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtils currentSubTabPageIndex]];
//        }
//    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [[LTStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LTUtils currentSubTabPageIndex] forSlideCount:1];
}


@end
