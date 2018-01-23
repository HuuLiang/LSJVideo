//
//  LSJBtnView.h
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchAction)(void);

@interface LSJBtnView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageV;
@property (nonatomic) BOOL isSelected;

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                        normalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage
                              space:(CGFloat)space
                       isTitleFirst:(BOOL)isTitleFirst
                        touchAction:(touchAction)action;

@end
