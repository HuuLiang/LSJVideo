//
//  LSJDetailVideoVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoVC.h"
#import "LSJDetailModel.h"
#import "LSJDetailVideoHeaderCell.h"
#import "LSJDetailVideoDescCell.h"
#import "LSJDetailVideoPhotosCell.h"
#import "LSJDetailVideoCommandCell.h"


@interface LSJDetailVideoVC ()
{
    NSInteger _programId;
    
    LSJDetailVideoHeaderCell * _headerCell;
    LSJDetailVideoDescCell  * _descCell;
    LSJDetailVideoPhotosCell *_photosCell;
    LSJDetailVideoCommandCell *_commandCell;
    
}
@property (nonatomic) LSJDetailModel *detailModel;
@end

@implementation LSJDetailVideoVC
DefineLazyPropertyInitialization(LSJDetailModel, detailModel)

- (instancetype)initWithProgram:(NSInteger)programId
{
    self = [super init];
    if (self) {
        _programId = programId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.hasRowSeparator = NO;
    
//    [self.layoutTableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(30), 0, kWidth(30))];
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    [self.layoutTableView LSJ_triggerPullToRefresh];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
//    @weakify(self);
//    [self.detailModel fetchProgramDetailInfoWithProgramId:_programId CompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
//        if (success) {
    [self.layoutTableView LSJ_endPullToRefresh];
            [self initCells];
//        }
    
//    }];
}

- (void)initCells {
    NSUInteger section = 0;
    
    [self initHeaderCellInSection:section++];
    [self initDescCellInSection:section++];
    if (1) {
        [self setHeaderHeight:kWidth(1) inSection:section];
        [self initPhotosCellInSection:section++];
    }
    [self setHeaderHeight:kWidth(20) inSection:section];
    
    [self initCommandCellInSection:section++];
    
    
//    for (NSUInteger count = 0 ; count < 10; ) {
//        <#statements#>
//    }
    
    
    
    [self initCommandDetailsInSection:section++];
    
    [self.layoutTableView reloadData];
}

- (void)initHeaderCellInSection:(NSUInteger)section {
    _headerCell = [[LSJDetailVideoHeaderCell alloc] init];
    _headerCell.imgUrlStr = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg";
    [self setLayoutCell:_headerCell cellHeight:kScreenWidth * 0.6 inRow:0 andSection:section];
}

- (void)initDescCellInSection:(NSUInteger)section {
    _descCell = [[LSJDetailVideoDescCell alloc] init];
    _descCell.titleStr = @"超级美少妇无码中出";
    _descCell.countStr = @"1111.1万";
    _descCell.tagAStr = @"偷拍";
    _descCell.tagBStr = @"巨乳";
    _descCell.tagAColor = [UIColor colorWithHexString:@"#C63C3C"];
    _descCell.tagBColor = [UIColor colorWithHexString:@"#4A90E2"];
    [self setLayoutCell:_descCell cellHeight:kWidth(140) inRow:0 andSection:section];
}

- (void)initPhotosCellInSection:(NSUInteger)section {
    _photosCell = [[LSJDetailVideoPhotosCell alloc] init];
    _photosCell.dataSource = @[@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg"];
    [self setLayoutCell:_photosCell cellHeight:kWidth(290) inRow:0 andSection:section];
}

- (void)initCommandCellInSection:(NSUInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_command"]];
    [cell addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"热门评论";
    label.textColor = [UIColor colorWithHexString:@"#E60039"];
    label.font = [UIFont systemFontOfSize:kWidth(32)];
    [cell addSubview:label];
    {
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(kWidth(16));
            make.size.mas_equalTo(CGSizeMake(kWidth(52), kWidth(52)));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(imgV.mas_right).offset(kWidth(14));
            make.height.mas_equalTo(kWidth(44));
        }];
    }
    
    
    [self setLayoutCell:cell cellHeight:kWidth(72) inRow:0 andSection:section];
}

- (void)initCommandDetailsInSection:(NSUInteger)section {
    [self setHeaderHeight:kWidth(1) inSection:section];
    NSString *str = @"超级美少妇无码中出超级美少妇无码中出超级美少妇无码中出超级美";
    CGFloat height = [str sizeWithFont:[UIFont systemFontOfSize:kWidth(30)] maxSize:CGSizeMake(kScreenWidth - kWidth(60), MAXFLOAT)].height;
    
    _commandCell = [[LSJDetailVideoCommandCell alloc] initWithHeight:height];
    _commandCell.userImgUrlStr = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg";
    _commandCell.userNameStr = @"花式撸炮";
    _commandCell.timeStr = @"asdasd";
    _commandCell.commandStr = str;
    
    [self setLayoutCell:_commandCell cellHeight:kWidth(140)+height inRow:0 andSection:section];
}

@end
