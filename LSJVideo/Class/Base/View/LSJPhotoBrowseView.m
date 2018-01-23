//
//  LSJPhotoBrowseView.m
//  LSJVideo
//
//  Created by Liang on 16/9/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPhotoBrowseView.h"
#import "SDCycleScrollView.h"


@interface LSJPhotoBrowseView () <SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_photoView;
    NSInteger _currentIndex;
}
@end


@implementation LSJPhotoBrowseView

- (instancetype)initWithUrlsArray:(NSArray *)array andIndex:(NSUInteger)index frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        _currentIndex = index;
        
        const CGFloat width = frame.size.width*0.9;
        const CGFloat heigh = width*9/7;
        const CGFloat pointX = frame.size.width*0.05;
        const CGFloat pointY = (frame.size.height - width *9/7)/2-kWidth(50);
        
        
        _photoView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(pointX, pointY, width, heigh)];
        _photoView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _photoView.autoScrollTimeInterval = 0.1;
        _photoView.autoScroll = NO;
        _photoView.titleLabelBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        _photoView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _photoView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _photoView.delegate = self;
        _photoView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        _photoView.imageURLStringsGroup = array;
        
        [self addSubview:_photoView];
        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    QBLog(@"%ld",index);
//    if (index == _currentIndex) {
//        _photoView.autoScroll = NO;
//    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 退出图片浏览
    self.closePhotoBrowse();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _photoView.currentPage = _currentIndex;
}


@end
