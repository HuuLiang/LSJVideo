//
//  LSJLaunchView.m
//  LSJVideo
//
//  Created by Liang on 16/9/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLaunchView.h"

@interface LSJLaunchView ()
{
    UIView *_view;
    UIImageView *_imageView;
}
@end

@implementation LSJLaunchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *launchImagePath = [[NSBundle mainBundle] pathForResource:@"launch" ofType:@"jpg"];
        
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
    
    [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        _imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
