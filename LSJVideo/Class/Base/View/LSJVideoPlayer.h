//
//  LSJVideoPlayer.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJVideoPlayer : UIView
@property (nonatomic) NSURL *videoURL;
- (instancetype)initWithVideoURL:(NSURL *)videoURL;
- (void)startToPlay;
- (void)pause;
@property (nonatomic,copy) QBAction endPlayAction;
@end
