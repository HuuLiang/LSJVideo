//
//  LSJBtnView.m
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBtnView.h"

@interface LSJBtnView ()
{
    UILabel *_titleLabel;
    
    UIImage *_normalImage;
    UIImage *_selectedImage;
    
    UIImageView *_imgV;
    
    CGSize _normalImageSize;
    CGSize _selectedImageSize;
    
    NSString *_normalTitleStr;
    NSString *_selectedTitleStr;
    
    BOOL _titleFirst;
}
@end

@implementation LSJBtnView

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                 isTitleFirst:(BOOL)titleFirst
{
    self = [super init];
    if (self) {
        _isSelected = NO;
        _space = 0.0f;
        _titleFirst = titleFirst;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:15.];
        [self addSubview:_titleLabel];
        
        if (normalImage) {
            _normalImage = normalImage;
            _normalImageSize = normalImage.size;
            _normalTitleStr = title;
            _imgV = [[UIImageView alloc] initWithImage:normalImage];
            [self addSubview:_imgV];
        }
        
        if (selectedImage) {
            _selectedImage = selectedImage;
            _selectedImageSize = selectedImage.size;
        }
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self.mas_centerX).offset(_normalImageSize.width / 2.* _titleFirst ? -1 : 1);

            }];
            
            if (_imgV) {
                [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(kWidth(_normalImageSize.width * 2), kWidth(_normalImageSize.height * 2)));
                    if (_titleFirst) {
                        make.left.equalTo(_titleLabel.mas_right).offset(0);
                    } else {
                        make.right.equalTo(_titleLabel.mas_left).offset(0);
                    }
                    
                }];
            }
        }
        @weakify(self)
        [self bk_whenTapped:^{
            @strongify(self);
            self.action();
        }];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor {
    self.backgroundColor = bgColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleLabel.font = titleFont;
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    if (_imgV) {
        [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            if (_titleFirst) {
                make.left.equalTo(_titleLabel.mas_right).offset(space);
            } else {
                make.right.equalTo(_titleLabel.mas_left).offset(-space);
            }
            
        }];
    }
}

- (void)setSelectedTitle:(NSString *)selectedTitle {
    _selectedTitleStr = selectedTitle;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected && _selectedImage) {
        _imgV.image = _selectedImage;
        _titleLabel.text = _selectedTitleStr;
        {
            [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWidth(_selectedImageSize.width * 2), kWidth(_selectedImageSize.height * 2)));
                if (_titleFirst) {
                    make.left.equalTo(_titleLabel.mas_right).offset(_space);
                } else {
                    make.right.equalTo(_titleLabel.mas_left).offset(_space);
                }
                
            }];
        }
        
    } else {
        _imgV.image = _normalImage;
        _titleLabel.text = _normalTitleStr;
        {
            [_imgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWidth(_normalImageSize.width * 2), kWidth(_normalImageSize.height * 2)));
                if (_titleFirst) {
                    make.left.equalTo(_titleLabel.mas_right).offset(_space);
                } else {
                    make.right.equalTo(_titleLabel.mas_left).offset(_space);
                }
                
            }];
        }
    }
}



@end
