//
//  LSJLechersCollectionView.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kLechersCollectionViewReusableIdentifier = @"kLechersCollectionViewReusableIdentifier";


@interface LSJLechersCollectionCell : UICollectionViewCell
@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *titleStr;
@end


@interface LSJLechersCollectionView : UICollectionView

//- (instancetype)init;

@end
