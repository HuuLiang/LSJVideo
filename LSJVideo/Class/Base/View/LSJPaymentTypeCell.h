//
//  LSJPaymentTypeCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJPaymentTypeCell : UITableViewCell

- (instancetype)initWithPaymentTypes:(NSArray *)availablePaymentTypes;

@property (nonatomic,retain) NSArray *availablePaymentTypes;
@property (nonatomic) UIButton *chooseBtn;

@property (nonatomic,copy) LSJSelectionAction selectionAction;

@property (nonatomic)QBPayType payType;
@property (nonatomic)QBPaySubType subType;

@end
