//
//  LSJReportView.h
//  LSJVideo
//
//  Created by Liang on 16/9/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popKeyboard)(void);


@interface LSJMessageView : UIView
@property (nonatomic) UIButton *sendBtn;
@property (nonatomic) UITextView *textView;
@end



@interface LSJReportView : UIView
@property (nonatomic) popKeyboard popKeyboard;
@end
