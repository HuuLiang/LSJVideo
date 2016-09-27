//
//  LSJLechersListCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersListCell.h"
#import "LSJLechersCollectionView.h"
#import "LSJBtnView.h"

@interface LSJLechersListCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UILabel *_titleLabel;
    LSJBtnView *_moreView;
    LSJLechersCollectionView *_layoutCollectionView;
}
@end

@implementation LSJLechersListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:bgView];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#fee102"];
        [bgView addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [bgView addSubview:_titleLabel];
        
        @weakify(self);
        _moreView = [[LSJBtnView alloc] initWithNormalTitle:@"更多" selectedTitle:@"更多" normalImage:[UIImage imageNamed:@"lecher_into"] selectedImage:[UIImage imageNamed:@"lecher_into"] space:kWidth(10) isTitleFirst:YES touchAction:^{
            @strongify(self);
            self.action(@(0));
        }];
        _moreView.userInteractionEnabled = YES;
        _moreView.titleLabel.font = [UIFont systemFontOfSize:kWidth(20)];
        _moreView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _moreView.layer.cornerRadius = kWidth(18);
        _moreView.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _moreView.layer.borderWidth = kWidth(2);
        _moreView.layer.masksToBounds = YES;
        _moreView.titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        [bgView addSubview:_moreView];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kWidth(10);
        layout.minimumInteritemSpacing = kWidth(0);
        layout.sectionInset = UIEdgeInsetsMake(0, kWidth(10), 0, kWidth(10));
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _layoutCollectionView = [[LSJLechersCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _layoutCollectionView.delegate = self;
        _layoutCollectionView.dataSource = self;
        [bgView addSubview:_layoutCollectionView];
        
        
        {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(kCellHeight - kWidth(20));
            }];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(kWidth(10));
                make.top.equalTo(bgView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(6), kWidth(36)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineView.mas_right).offset(kWidth(10));
                make.centerY.equalTo(lineView);
                make.height.mas_equalTo(kWidth(44));
            }];
            
            [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_titleLabel);
                make.right.equalTo(bgView.mas_right).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(94), kWidth(36)));
            }];

            [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(15));
                make.left.right.equalTo(bgView);
                make.height.mas_equalTo(kImageWidth * 9 / 7 + kWidth(20));
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [_layoutCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJLechersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLechersCollectionViewReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < _dataArr.count) {
        LSJColumnModel *column = _dataArr[indexPath.item];
        cell.imgUrlStr = column.columnImg;
        cell.titleStr = column.name;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kImageWidth, kImageWidth * 9 /7);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.item < _dataArr.count) {
        @strongify(self);
        self.action(@(indexPath.item));
    }
}



@end
