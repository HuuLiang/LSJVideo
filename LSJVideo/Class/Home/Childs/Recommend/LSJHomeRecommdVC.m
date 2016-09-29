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

#import "LSJColumnConfigModel.h"

#import "SDCycleScrollView.h"

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
@property (nonatomic) LSJColumnConfigModel *programModel;
@property (nonatomic) LSJColumnModel *bannerColoumnModel;
@end

@implementation LSJHomeRecommdVC
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
    
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    [_bannerView aspect_hookSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIScrollView *scrollView, BOOL decelerate){
        [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:1 forBanner:@(self.bannerColoumnModel.columnId) withSlideCount:1];
    } error:nil];
    
    
    UICollectionViewFlowLayout *freeLayout = [[UICollectionViewFlowLayout alloc] init];
    freeLayout.minimumLineSpacing = 5;
    freeLayout.minimumInteritemSpacing = 5;
    [freeLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _freeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:freeLayout];
    _freeCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _freeCollectionView.delegate = self;
    _freeCollectionView.dataSource = self;
    _freeCollectionView.showsVerticalScrollIndicator = NO;
    _freeCollectionView.showsHorizontalScrollIndicator = NO;
    [_freeCollectionView registerClass:[LSJRecommdCell class] forCellWithReuseIdentifier:kRecommendCellReusableIdentifier];
    [_freeCollectionView registerClass:[LSJHomeSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeSectionHeaderReusableIdentifier];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = 0;
    mainLayout.minimumInteritemSpacing = kWidth(5);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[LSJRecommdCell class] forCellWithReuseIdentifier:kRecommendCellReusableIdentifier];
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
    [self.programModel fetchColumnsInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
//            for (LSJColumnModel *model in obj) {
//                if (model.showNumber == 6) {
//                    model.showMode = 1;
//                } else if (model.showNumber == 10) {
//                    model.showMode = 2;
//                }
//                if ((model.type == 3 && [LSJUtil isVip]) || (model.type == 5 && ![LSJUtil isVip]) || model.type == 1 || model.type == 4) {
//                    [self.dataSource addObject:model];
//                }
//            }

            [_layoutCollectionView LSJ_endPullToRefresh];
            [self refreshBannerView];
            [_layoutCollectionView reloadData];
        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *imageUrlGroup = [NSMutableArray array];
    NSMutableArray *titlesGroup = [NSMutableArray array];
    
    for (LSJColumnModel *column in self.dataSource) {
        if (column.type == 4) {
            self.bannerColoumnModel = column;
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
    if (collectionView == _layoutCollectionView) {
        return self.dataSource.count;
    } else if (collectionView == _freeCollectionView) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _layoutCollectionView) {
        LSJColumnModel *model = self.dataSource[section];
        if (model.type == 4 || model.type == 3) {
            return 1;
        } else if (model.type == 1) {
            return model.programList.count;
        } else if (model.type == 5) {
            if ([LSJUtil isVip]) {
                return 0;
            } else {
                return 1;
            }
        }
        else {
            return 0;
        }
    } else if (collectionView == _freeCollectionView) {
        for (LSJColumnModel * model in self.dataSource) {
            if (model.type == 5) {
                return model.programList.count;
            }
        }
        return 0;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSJRecommdCell *recommendCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCellReusableIdentifier forIndexPath:indexPath];
    
    if (collectionView == _layoutCollectionView) {
        LSJColumnModel *column = _dataSource[indexPath.section];
        
        LSJProgramModel *program = column.programList[indexPath.item];
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
            [_freeCollectionView reloadData];
            return _freeCell;
        } else {
            recommendCell.title = program.title;
            recommendCell.imgUrl = program.coverImg;
            return recommendCell;
        }
    } else if (collectionView == _freeCollectionView) {
        for (LSJColumnModel *column in _dataSource) {
            if (column.type == 5) {
                if (indexPath.item < column.programList.count) {
                    LSJProgramModel *program = column.programList[indexPath.item];
                    recommendCell.title = program.title;
                    recommendCell.imgUrl = program.coverImg;
                    recommendCell.isFree = YES;
                    return recommendCell;
                }
            }
        }
        return nil;
        
    } else {
        return nil;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutCollectionView) {
        LSJHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
        LSJColumnModel *column = _dataSource[indexPath.section];
        headerView.titleStr = column.name;
        return headerView;
    } else {
        LSJHomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHomeSectionHeaderReusableIdentifier forIndexPath:indexPath];
        return headerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutCollectionView) {
        if (indexPath.section < _dataSource.count) {
            LSJColumnModel *column = _dataSource[indexPath.section];
            if (indexPath.item < column.programList.count) {
                LSJProgramModel *program = column.programList[indexPath.item];
                LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:0 subTab:1];
                if (column.type != 5) {
                    [self pushToDetailVideoWithController:self ColumnId:column.columnId program:program baseModel:baseModel];
                }
                [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:1];
            }
        }
    } else if (collectionView == _freeCollectionView) {
        for (LSJColumnModel *column in _dataSource) {
            if (column.type == 5) {
                LSJProgramModel *program = column.programList[indexPath.item];
                LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:4 subTab:1];
                [self playVideoWithUrl:program.videoUrl baseModel:baseModel];
                [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:1];
            }
        }
    }
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutCollectionView) {
        CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
        LSJColumnModel *column = _dataSource[indexPath.section];
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        CGFloat width;
        CGFloat height;
        if (column.type == 4 || (column.type == 3 && [LSJUtil isVip])) {
            return CGSizeMake(fullWidth, fullWidth/2.);
        } else if (column.type == 1 && column.showMode == 1) {
            if (indexPath.item == 0) {
                width = fullWidth - insets.left - insets.right;
                height = floorf(width / 3 + kWidth(68));
                return CGSizeMake((long)width, (long)height);
            } else {
                width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing) / 2;
                height = width * 0.6 + kWidth(68);
                return CGSizeMake(width, height);
            }
        } else if (column.type == 1 && column.showMode == 2) {
            width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
            height = width * 9 / 7. + kWidth(68);
            return CGSizeMake((long)width, (long)height);
        } else if (column.type == 5 && ![LSJUtil isVip]) {
            width = fullWidth;
            height = (fullWidth / 2.5) * 9 / 7 + kWidth(68);
            return CGSizeMake((long)width, (long)height);
        } else {
            return CGSizeZero;
        }
    } else if (collectionView == _freeCollectionView) {
        CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        CGFloat width;
        CGFloat height;
        width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 2.5;
        height = width * 9 /7 + kWidth(68);
        return CGSizeMake((long)width, (long)height);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == _layoutCollectionView) {
        LSJColumnModel *column = _dataSource[section];
        if (column.type == 4) {
            return UIEdgeInsetsMake(0., 0., 0, 0.);
        } else if (column.type == 1) {
            return UIEdgeInsetsMake(kWidth(5), kWidth(5), kWidth(5), kWidth(5));
        } else {
            return UIEdgeInsetsZero;
        }
    } else if (collectionView == _freeCollectionView) {
        return UIEdgeInsetsMake(5., 5., 5., 5.);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _layoutCollectionView) {
        LSJColumnModel *column = _dataSource[section];
        
        if ((column.type == 5 && ![LSJUtil isVip]) || column.type == 1) {
            UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
            return CGSizeMake(CGRectGetWidth(collectionView.bounds)-insets.left-insets.right, kWidth(100));
        } else {
            return CGSizeMake(0, 0);
        }
    } else if (collectionView == _freeCollectionView) {
        return CGSizeMake(0, 0);
    } else {
        return CGSizeZero;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    for (LSJColumnModel *column in _dataSource) {
        if (column.type == 4 && index < column.programList.count) {
            LSJProgramModel *program = column.programList[index];
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:index Spec:NSNotFound subTab:1];
            [self pushToDetailVideoWithController:self ColumnId:column.columnId program:program baseModel:baseModel];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:1];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:1 forSlideCount:1];
}



@end
