//
//  LSJPaymentPopView.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LSJPaymentPopViewAction)(QBPayType paymentType,QBPaySubType subType,LSJVipLevel vipLevel);

@interface LSJPaymentPopView : UITableView

@property (nonatomic,retain) NSArray *availablePaymentTypes;

@property (nonatomic,copy) LSJPaymentPopViewAction paymentAction;

@property (nonatomic,copy) QBAction closeAction;

- (instancetype)initWithAvailablePaymentTypes:(NSArray *)availablePaymentTypes;

@end
