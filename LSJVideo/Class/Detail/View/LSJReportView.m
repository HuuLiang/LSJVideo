//
//  LSJReportView.m
//  LSJVideo
//
//  Created by Liang on 16/9/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJReportView.h"
#import "LSJBtnView.h"

@interface LSJMessageView () <UITextViewDelegate>
{
//    UITextField *_textView;
//    UIButton *_sendBtn;
    CGFloat offsetY;
}

@end

@implementation LSJMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(kWidth(30), kWidth(10), kScreenWidth-kWidth(60), kWidth(120))];
        _textView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        _textView.textColor = [UIColor colorWithHexString:@"#000000"];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        [self addSubview:_textView];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(kScreenWidth - kWidth(150), kWidth(150), kWidth(120), kWidth(50));
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor clearColor];
        _sendBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _sendBtn.layer.borderWidth = 1.;
        
        [self addSubview:_sendBtn];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardActionHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}


- (void)handleKeyBoardActionHide:(NSNotification *)notification {
    self.frame = CGRectMake(0, kScreenHeight - 64, self.frame.size.width, kWidth(210));
}

- (void)handleKeyBoardChangeFrame:(NSNotification *)notification {

    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(endFrame));
    
    self.frame = CGRectMake(0, endFrame.origin.y - kWidth(210) - 64, self.frame.size.width, kWidth(210));
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textView resignFirstResponder];
    return YES;
}
@end

@interface LSJReportView ()
{
    LSJBtnView *_btnView;
    LSJMessageView *_messageView;
}
@end

@implementation LSJReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffe203"];

        @weakify(self);
        _btnView = [[LSJBtnView alloc] initWithNormalTitle:@"发表评论" selectedTitle:@"发表评论" normalImage:[UIImage imageNamed:@"detail_report"] selectedImage:[UIImage imageNamed:@"detail_report"] space:kWidth(20) isTitleFirst:NO touchAction:^{
            @strongify(self);
            self.popKeyboard();
        }];
        _btnView.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];

        [self addSubview:_btnView];
        
        {
            [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(80)));
            }];
        }
        
        [self bk_whenTapped:^{
            @strongify(self);
            self.popKeyboard();
        }];
    }
    return self;
}

@end
