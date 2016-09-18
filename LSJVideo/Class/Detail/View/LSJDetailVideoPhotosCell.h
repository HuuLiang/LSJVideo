//
//  LSJDetailVideoPhotosCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJDetailVideoPhotosCollectionCell : UICollectionViewCell

@end

@interface LSJDetailVideoPhotosCell : UITableViewCell
@property (nonatomic) NSArray *dataSource;

@property (nonatomic) LSJAction selectedIndex;
@end
