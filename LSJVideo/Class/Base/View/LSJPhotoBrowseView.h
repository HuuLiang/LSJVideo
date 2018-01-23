//
//  LSJPhotoBrowseView.h
//  LSJVideo
//
//  Created by Liang on 16/9/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closePhotoBrowse)(void);

@interface LSJPhotoBrowseView : UIView

- (instancetype)initWithUrlsArray:(NSArray *)array andIndex:(NSUInteger)index frame:(CGRect)frame;

@property (nonatomic) closePhotoBrowse closePhotoBrowse;

@end
