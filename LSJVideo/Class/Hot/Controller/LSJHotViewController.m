//
//  LSJHotViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHotViewController.h"
#import "LSJHotModel.h"
#import "LSJProgramConfigModel.h"
#import "LSJHotTitleCell.h"
#import "LSJHotContentCell.h"
#import "LSJBtnView.h"


#define LINESPACING kScreenWidth * 10 / 375.
#define INTERITEMSPACING kScreenWidth * 23 / 750.
#define EDGINSETS UIEdgeInsetsMake(kScreenWidth * 25 / 750., kScreenWidth * 30 / 750. , kScreenWidth * 25 / 750., kScreenWidth * 30 / 750.)
#define titleCellHeight 2* kScreenWidth * 48/750. + LINESPACING + EDGINSETS.top + EDGINSETS.bottom + kScreenWidth * 48 / 750.

static NSString *const kHotTitleCellReusableIdentifier = @"hottitleCellReusableIdentifier";
static NSString *const kDetailProgramCellReusableIdentifier = @"DetailProgramCellReusableIdentifier";

@interface LSJHotViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSUInteger _columnId;
    NSIndexPath *_selectecIndexPath;
    NSIndexPath *_lastSelectedIndexPath;
    BOOL _isRefresh;
    
    LSJBtnView *_btnView;
    
    UITableViewCell *_titleCell;
    UICollectionView *_layoutTitleCollectionView;
    
    UITableViewCell *_headerCell;
    UILabel *_label;
    
    UITableViewCell *_detailCell;
    UICollectionView *_layoutDetailCollectionView;
}
@property (nonatomic) LSJHotModel * hotModel;
@property (nonatomic) LSJProgramConfigModel *programConfigModel;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableArray *titleWidthArray;
@property (nonatomic) NSMutableArray *detailArray;
@property (nonatomic) LSJColumnModel *coloumModel;
@end

@implementation LSJHotViewController
QBDefineLazyPropertyInitialization(LSJHotModel, hotModel)
QBDefineLazyPropertyInitialization(LSJProgramConfigModel, programConfigModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, titleWidthArray)
QBDefineLazyPropertyInitialization(NSMutableArray, detailArray)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectecIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _isRefresh = NO;
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    [self.layoutTableView LSJ_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadData];
    }];
    [self.layoutTableView LSJ_triggerPullToRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self.layoutTableView LSJ_triggerPullToRefresh];
            }];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    @weakify(self);
    [self.hotModel fetchHotInfoWithCompletionHadler:^(BOOL success, id obj) {
        @strongify(self);
        [self.layoutTableView LSJ_endPullToRefresh];
        [self removeCurrentRefreshBtn];
        if (success) {
            _isRefresh = YES;
            [self.dataSource removeAllObjects];
            [self.titleWidthArray removeAllObjects];
            [self titleItemWidth:obj];
            [self.dataSource addObjectsFromArray:obj];
            [self reloadUI];
        }else {
            if (self.dataSource.count == 0) {
                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                    @strongify(self);
                    [self.layoutTableView LSJ_triggerPullToRefresh];
                }];
            }
        }
    }];
}

- (void)loadProgramsWithColumnInfo:(LSJColumnModel *)column {
    if (_lastSelectedIndexPath == _selectecIndexPath && !_isRefresh) {
        return;
    }
    _isRefresh = YES;
    
    @weakify(self);
    [self.programConfigModel fetchProgramsInfoWithColumnId:column.columnId IsProgram:YES CompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        @strongify(self);
        if (success) {
            [self.detailArray removeAllObjects];
            [self.detailArray addObjectsFromArray:obj.programList];
            self.coloumModel = obj;
            [self initHeaderCell:1 column:column];
            [self initDetailCell:2 column:column];
            
        }
        if (!success || obj.programList.count == 0) {
            [[LSJHudManager manager] showHudWithText:@"数据加载失败,请稍后再试"];
            
        }
        _isRefresh = NO;
    }];
    
    _lastSelectedIndexPath = _selectecIndexPath;
}

- (void)titleItemWidth:(NSArray *)array {
    CGFloat fullwidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
    NSInteger count = 0;
    CGFloat currentWidth = 0;
    CGFloat nextWidth = 0;
    CGFloat rowWidth = fullwidth;
    for (NSInteger i = 0; i < array.count ; i++) {
        LSJColumnModel *columnModel = array[i];
        if (i == 0) {
            currentWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:kWidth(26)] maxSize:CGSizeMake(MAXFLOAT, kWidth(48))].width + 30.;
        } else {
            currentWidth = nextWidth;
        }
        
        if (i + 1 < array.count) {
            columnModel = array[i + 1];
            nextWidth = [columnModel.name sizeWithFont:[UIFont systemFontOfSize:kWidth(26)] maxSize:CGSizeMake(MAXFLOAT, kWidth(48))].width + 30.;
            if (rowWidth - currentWidth - INTERITEMSPACING >= nextWidth && count < 3) {
                count++;
                rowWidth = rowWidth - currentWidth - INTERITEMSPACING;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                count = 0;
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
                rowWidth = kScreenWidth - EDGINSETS.left - EDGINSETS.right;
            }
        } else {
            if (count <= 3 && rowWidth > currentWidth) {
                currentWidth = rowWidth;
                [self.titleWidthArray addObject:@((long)currentWidth)];
            } else {
                [self.titleWidthArray addObject:@((long)currentWidth)];
            }
        }
    }
}

- (void)reloadUI {
    [self removeAllLayoutCells];
    [self initTitleCell:0];
    [self.layoutTableView reloadData];
    [self collectionView:_layoutTitleCollectionView didSelectItemAtIndexPath:_selectecIndexPath];
}

- (void)initTitleCell:(NSUInteger)section {
    _titleCell = [[UITableViewCell alloc] init];
    _titleCell.backgroundColor = [UIColor clearColor];
    _titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = LINESPACING;
    layout.minimumInteritemSpacing = INTERITEMSPACING;
    
    _layoutTitleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutTitleCollectionView.backgroundColor = [UIColor clearColor];
    _layoutTitleCollectionView.delegate = self;
    _layoutTitleCollectionView.dataSource = self;
    _layoutTitleCollectionView.showsVerticalScrollIndicator = NO;
    _layoutTitleCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _layoutTitleCollectionView.scrollEnabled = NO;
    [_layoutTitleCollectionView registerClass:[LSJHotTitleCell class] forCellWithReuseIdentifier:kHotTitleCellReusableIdentifier];
    [_titleCell addSubview:_layoutTitleCollectionView];
    
    @weakify(self);
    _btnView = [[LSJBtnView alloc] initWithNormalTitle:@"更多" selectedTitle:@"收起" normalImage:[UIImage imageNamed:@"hot_more_icon"] selectedImage:[UIImage imageNamed:@"hot_less_icon"] space:kWidth(10) isTitleFirst:YES touchAction:^{
        @strongify(self);
        if (!self->_btnView.isSelected) {
            self->_btnView.isSelected = !self->_btnView.isSelected;
            self->_layoutTitleCollectionView.scrollEnabled = YES;
            self->_layoutTitleCollectionView.showsVerticalScrollIndicator = YES;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self->_titleCell.frame = CGRectMake(0, 0, kScreenWidth, titleCellHeight + 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
                self->_headerCell.transform = CGAffineTransformMakeTranslation(0, 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
                self->_detailCell.transform = CGAffineTransformMakeTranslation(0, 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2);
            } completion:^(BOOL finished) {
                [self setLayoutCell:self->_titleCell cellHeight:titleCellHeight + 2.5 * kScreenWidth * 48/750. +  LINESPACING * 2 inRow:0 andSection:0];
                [self.layoutTableView reloadData];
            }];
        } else {
            self->_btnView.isSelected = !self->_btnView.isSelected;
            self->_layoutTitleCollectionView.scrollEnabled = NO;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self->_titleCell.frame = CGRectMake(0, 0, kScreenWidth, titleCellHeight);
                self->_headerCell.transform = CGAffineTransformMakeTranslation(0, 0);
                self->_detailCell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                [self setLayoutCell:self->_titleCell cellHeight:titleCellHeight inRow:0 andSection:0];
                [self.layoutTableView reloadData];
            }];
            
            [self->_layoutTitleCollectionView scrollToItemAtIndexPath:self->_selectecIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }];
    _btnView.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    [_titleCell addSubview:_btnView];
    
    {
        [_layoutTitleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_titleCell);
            make.bottom.equalTo(_titleCell.mas_bottom).offset(-(kScreenWidth * 48 /750. + LINESPACING));
        }];
        
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_titleCell).offset(0);
            make.centerX.equalTo(_titleCell);
            make.size.mas_equalTo(CGSizeMake(68/375.*kScreenWidth,kScreenWidth * 24 /375. + LINESPACING));
        }];
    }
    
    [self setLayoutCell:_titleCell cellHeight:titleCellHeight inRow:0 andSection:0];
}


- (void)initHeaderCell:(NSUInteger)section column:(LSJColumnModel *)column {
    _headerCell = [[UITableViewCell alloc] init];
    _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerCell.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _label = [[UILabel alloc] init];
    _label.textColor = [[UIColor colorWithHexString:@"#222222"] colorWithAlphaComponent:0.54];
    _label.font = [UIFont systemFontOfSize:kWidth(30)];
    _label.text = [NSString stringWithFormat:@"共搜索到%ld部\"%@\"的作品",_detailArray.count,column.name];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_headerCell addSubview:_label];
    {
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headerCell.mas_bottom);
            make.left.right.equalTo(_headerCell);
            make.height.mas_equalTo(kWidth(60));
        }];
    }
    [self setLayoutCell:_headerCell cellHeight:kWidth(80) inRow:0 andSection:section++];
}
- (void)initDetailCell:(NSUInteger)section column:(LSJColumnModel *)column {
    _detailCell = [[UITableViewCell alloc] init];
    _detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _detailCell.backgroundColor = [UIColor clearColor];
    
    _label.text = [NSString stringWithFormat:@"共搜索到%ld部\"%@\"的作品",_detailArray.count,column.name];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    _layoutDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutDetailCollectionView.backgroundColor = [UIColor clearColor];
    _layoutDetailCollectionView.delegate = self;
    _layoutDetailCollectionView.dataSource = self;
    _layoutDetailCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutDetailCollectionView registerClass:[LSJHotContentCell class] forCellWithReuseIdentifier:kDetailProgramCellReusableIdentifier];
    _layoutDetailCollectionView.scrollEnabled = NO;
    [_detailCell addSubview:_layoutDetailCollectionView];
    {
        [_layoutDetailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_detailCell);
        }];
    }
    
    const CGFloat fullWidth = kScreenWidth;
    const CGFloat width = (fullWidth - 2*layout.minimumLineSpacing - EDGINSETS.left - EDGINSETS.right)/3;
    const CGFloat height = width * 300 / 227. + kWidth(30);
    NSInteger itemLines = self.detailArray.count % 3 == 0 ? (self.detailArray.count / 3) : (self.detailArray.count / 3 + 1);
    CGFloat collectionViewHeight =  (itemLines - 1) * 5 + EDGINSETS.bottom + EDGINSETS.top + itemLines * height;
    [self setLayoutCell:_detailCell cellHeight:collectionViewHeight inRow:0 andSection:section];
    
    [self.layoutTableView reloadData];
    
    [_layoutTitleCollectionView selectItemAtIndexPath:_selectecIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _layoutTitleCollectionView) {
        return self.dataSource.count;
    } else if (collectionView == _layoutDetailCollectionView) {
        return self.detailArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutTitleCollectionView) {
        LSJHotTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotTitleCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.dataSource.count) {
            LSJColumnModel *column = self.dataSource[indexPath.item];
            cell.title = column.name;
            if (indexPath.item == _selectecIndexPath.item) {
                
            }
            return cell;
        }
    } else if (collectionView == _layoutDetailCollectionView) {
        LSJHotContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailProgramCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.detailArray.count) {
            LSJProgramModel *program = self.detailArray[indexPath.item];
            cell.titleStr = program.title;
            cell.imgUrlStr = program.coverImg;
            return cell;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutTitleCollectionView) {
        LSJColumnModel *column = self.dataSource[indexPath.item];
        if (indexPath.item < self.dataSource.count) {
            _columnId = column.columnId;
            _selectecIndexPath = indexPath;
            [_layoutTitleCollectionView scrollToItemAtIndexPath:_selectecIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self loadProgramsWithColumnInfo:column];
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:nil ProgramType:nil RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:NSNotFound];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
            
            //            JFBaseModel *baseModel = [[JFBaseModel alloc] init];
            //            baseModel.realColumnId = @(column.realColumnId);
            //            baseModel.channelType = @(column.type);
            //            baseModel.programLocation = indexPath.item;
            //            
            //            [[JFStatsManager sharedManager] statsCPCWithBeseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
        }
    } else if (collectionView == _layoutDetailCollectionView) {
        if (indexPath.item < self.detailArray.count) {
            LSJProgramModel *program = self.detailArray[indexPath.item];
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(self.coloumModel.realColumnId) ChannelType:@(self.coloumModel.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:NSNotFound];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound];
            [self pushToDetailVideoWithController:self ColumnId:_columnId program:program baseModel:baseModel];
            
        }
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _layoutTitleCollectionView) {
        const CGFloat width = [self.titleWidthArray[indexPath.item] floatValue];
        const CGFloat height = kScreenWidth * 48 / 750.;
        return CGSizeMake(width , height);
    } else if (collectionView == _layoutDetailCollectionView) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_layoutDetailCollectionView.collectionViewLayout;
        const CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
        UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
        const CGFloat width = (fullWidth - 2*layout.minimumInteritemSpacing  - insets.left - insets.right)/3.;
        const CGFloat height = width * 9 / 7+ kWidth(30);
        return CGSizeMake((long)width , (long)height);
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return EDGINSETS;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forSlideCount:1];
}



@end
