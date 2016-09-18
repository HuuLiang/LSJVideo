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

- (instancetype)initWithUrlsArray:(NSArray *)array andIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _currentIndex = index;
        
        _photoView = [[SDCycleScrollView alloc] init];
        _photoView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _photoView.autoScrollTimeInterval = 0.1;
        _photoView.autoScroll = NO;
        _photoView.titleLabelBackgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        _photoView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _photoView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _photoView.delegate = self;
        _photoView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        
        [self addSubview:_photoView];
        
        {
            [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _photoView.imageURLStringsGroup = array;
        _photoView.currentPage = index;
    }
    
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    DLog(@"%ld",index);
//    if (index == _currentIndex) {
//        _photoView.autoScroll = NO;
//    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 退出图片浏览
    self.closePhotoBrowse();
}



@end
