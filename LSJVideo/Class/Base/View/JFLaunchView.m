//
//  JFLaunchView.m
//  JFVideo
//
//  Created by Liang on 16/7/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFLaunchView.h"

@interface JFLaunchView ()
{
    UIView *_view;
    UIImageView *_imageView;
}
@end

@implementation JFLaunchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *launchImagePath = [[NSBundle mainBundle] pathForResource:@"launch_image" ofType:@"jpg"];
        _imageView.image = [UIImage imageWithContentsOfFile:launchImagePath];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow.subviews containsObject:keyWindow]) {
        return ;
    }
    
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];

    [UIView animateWithDuration:1.5 delay:1. options:UIViewAnimationOptionCurveEaseIn  animations:^{
        _imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:2. options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -0.0005;
////    transform = CATransform3DMakeRotation(radians(90), 0., 1., 0.);
//    [_imageView.layer setTransform:transform];
//    UIView
    
//    [self transitionWithType:@"SuckEffect" WithSubType:kCATransitionFromTop forView:_imageView];
}

//- (void)transitionWithType:(NSString *)type WithSubType:(NSString *)subType forView:(UIView *)view {
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.0;
//    animation.type = type;
//    if (subType != type) {
//        animation.subtype = subType;
//    }
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
//    
//    [view.layer addAnimation:animation forKey:@"animation"];
//}
//

//double kWidth(float width) {
//    return  kScreenWidth * width / 750;
//}
//
//double kHeight(float height) {
//    return kScreenHeight * height / 1334.;
//}

@end
