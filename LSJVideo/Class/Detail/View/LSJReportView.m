//
//  LSJReportView.m
//  LSJVideo
//
//  Created by Liang on 16/9/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJReportView.h"
#import "LSJBtnView.h"

@interface LSJMessageView () <UITextFieldDelegate>
{
    UITextField *_textField;
//    UIButton *_sendBtn;
}
@end

@implementation LSJMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textField = [[UITextField alloc] init];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self addSubview:_textField];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_sendBtn];
        
        {
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(250), kWidth(60)));
            }];
            
            [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(60)));
            }];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)handleKeyBoardAction:(NSNotification *)notification {
    NSLog(@"%@",notification);
    //1、计算动画前后的差值
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat detalY = endFrame.origin.y - beginFrame.origin.y;
    
    //2、根据差值更改_textView的高度
    UIView *superView = (UIView *)[self superview];
    
    
    CGFloat frame = self.frame.origin.y;
//    frame += detalY;
//    self.views.frame = CGRectMake(0, frame, self.view.frame.size.width, 40);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    return YES;
}
@end




@interface LSJReportView ()
{
    LSJBtnView *_btnView;
}
@end

@implementation LSJReportView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffe203"];

        _btnView = [[LSJBtnView alloc] initWithTitle:@"发表评论" normalImage:[UIImage imageNamed:@"detail_report"] selectedImage:nil isTitleFirst:NO];
        _btnView.titleColor = [UIColor colorWithHexString:@"#555555"];
        _btnView.titleFont = [UIFont systemFontOfSize:kWidth(32)];
        _btnView.space = kWidth(20);
        [self addSubview:_btnView];
        {
            [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).offset(kWidth(20));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(80)));
            }];
        }
        @weakify(self);
        _btnView.action = ^ {
            @strongify(self);
            self.popKeyboard();
        };
    }
    return self;
}

@end
