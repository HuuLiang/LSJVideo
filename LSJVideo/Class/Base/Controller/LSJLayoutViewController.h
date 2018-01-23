//
//  LSJLayoutViewController.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"

typedef void (^YPBLayoutTableViewAction)(NSIndexPath *indexPath, UITableViewCell *cell);

@interface LSJLayoutViewController : LSJBaseViewController <UITableViewSeparatorDelegate,UITableViewDataSource>

@property (nonatomic,retain,readonly) UITableView *layoutTableView;
@property (nonatomic,copy) YPBLayoutTableViewAction layoutTableViewAction;

// Cell & Cell Height
- (void)setLayoutCell:(UITableViewCell *)cell
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)removeAllLayoutCells;

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary<NSIndexPath *, UITableViewCell *> *)allCells;

// Header height & title
- (void)setHeaderHeight:(CGFloat)height inSection:(NSUInteger)section;
- (void)setHeaderTitle:(NSString *)title height:(CGFloat)height inSection:(NSUInteger)section;

@end
