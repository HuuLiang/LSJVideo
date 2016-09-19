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
/**
 *  @param title         标题
 *  @param normalImage   非选中状态图片  
 *  @param selectedImage 选中图片      可不传
 *  @Param titleFitst    是否文字在左
 */
- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                 isTitleFirst:(BOOL)titleFirst;


/**
 *  文字背景色  默认白色
 */
@property (nonatomic) UIColor *bgColor;

/**
 *  设置文字颜色 默认黑色
 */
@property (nonatomic) UIColor *titleColor;

/**
 *  文字大小 默认15
 */
@property (nonatomic) UIFont *titleFont;

/**
 *  文字图片间隔  默认0
 */
@property (nonatomic) CGFloat space;

/**
 *  触摸事件
 */
@property (nonatomic) touchAction action;

/**
 *  是否选中状态 用于更换图片 默认 NO
 */
@property (nonatomic) BOOL isSelected;

/**
 *  选中状态下的文字标题
 */
@property (nonatomic) NSString *selectedTitle;

@end
