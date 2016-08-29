//
//  LSJDetailVideoPhotosCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoPhotosCell.h"

static NSString *const kPhotosCollectionCellReusableIdentifier = @"kPhotosCollectionCellReusableIdentifier";

@interface LSJDetailVideoPhotosCollectionCell ()
{
    UIImageView *_imgV;
}
@property (nonatomic) NSString *imgUrlStr;
@end

@implementation LSJDetailVideoPhotosCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

@end


@interface LSJDetailVideoPhotosCell () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_photoCollectionView;
}
@end

@implementation LSJDetailVideoPhotosCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kWidth(20);
        layout.minimumInteritemSpacing = kWidth(0);
        layout.sectionInset = UIEdgeInsetsMake(kWidth(10), kWidth(20), kWidth(20), kWidth(20));
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_photoCollectionView registerClass:[LSJDetailVideoPhotosCollectionCell class] forCellWithReuseIdentifier:kPhotosCollectionCellReusableIdentifier];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.backgroundColor = [UIColor clearColor];
        _photoCollectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_photoCollectionView];
        
        {
            [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.centerY.equalTo(self);
                make.height.mas_equalTo(kWidth(290));
            }];
        }
        
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    [_photoCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSJDetailVideoPhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotosCollectionCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < _dataSource.count) {
        cell.imgUrlStr = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg";
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat width = (kScreenWidth - 4*kWidth(20)) / 3.5;
    const CGFloat height = width * 9 / 7;
    return CGSizeMake((long)width, (long)height);
}

@end
