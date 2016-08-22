//
//  LSJLechersCollectionView.m
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersCollectionView.h"

@interface LSJLechersCollectionCell ()
{
    UIImageView *_imgV;
    UILabel *_titleLabel;
}
@end

@implementation LSJLechersCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = kWidth(8);
        self.layer.masksToBounds = YES;
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        UIView *shadeView = [[UIView alloc] init];
        shadeView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.25];
        [self addSubview:shadeView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(38)];
        [self addSubview:_titleLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.height.mas_equalTo(kWidth(52));
            }];
        }
        
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

@end



@interface LSJLechersCollectionView ()

@end

@implementation LSJLechersCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = kWidth(10);
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        self.collectionViewLayout = layout;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        self.backgroundColor = [UIColor yellowColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[LSJLechersCollectionCell class] forCellWithReuseIdentifier:kLechersCollectionViewReusableIdentifier];
        
    }
    return self;
}
@end
