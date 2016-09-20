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

#import "LSJDetailImgTextHeaderCell.h"

#import "LSJDetailVideoCommandCell.h"

#import "LSJReportView.h"

@interface LSJDetailVideoVC ()
{
    NSInteger _programId;
    
    LSJDetailVideoHeaderCell * _headerCell;
    LSJDetailVideoDescCell  * _descCell;
    LSJDetailVideoPhotosCell *_photosCell;
    
    LSJDetailImgTextHeaderCell *_imgTextCell;
    
    LSJDetailVideoCommandCell *_commandCell;
    
    LSJReportView *_reportView;
    LSJMessageView *_messageView;
    
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
    
    
    _messageView = [[LSJMessageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-kWidth(80), kScreenWidth, kWidth(80))];
    [self.view addSubview:_messageView];
    
    [_messageView.sendBtn bk_addEventHandler:^(id sender) {
        [_messageView.textField becomeFirstResponder];
        if ([LSJUtil isVip]) {
            if (_messageView.textField.text.length < 1) {
                [[CRKHudManager manager] showHudWithText:@"您输入的评论过短"];
            }
            [[CRKHudManager manager] showHudWithText:@"请等待审核"];
            _messageView.textField.text = @"";
        } else {
            [[CRKHudManager manager] showHudWithText:@"非VIP用户不可发表评论"];
            _messageView.textField.text = @"";
            [_messageView.textField resignFirstResponder];
            [self playVideoWithUrl:@""];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _reportView = [[LSJReportView alloc] init];
    @weakify(self);
    _reportView.popKeyboard = ^{
        @strongify(self);
        [self->_messageView.textField becomeFirstResponder];
    };
    [self.view addSubview:_reportView];
    
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(kScreenHeight-80);
        }];
        
        [_reportView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(80));
        }];
    }
    
    
    [self.layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    [self.layoutTableView LSJ_triggerPullToRefresh];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if ([self->_messageView.textField isFirstResponder]) {
            [self->_messageView.textField resignFirstResponder];
            return ;
        }
        if (cell == self->_headerCell) {
            [self playVideoWithUrl:@""];
        }
        
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
    NSInteger count = 1;
    if (count == 2) {
        [self initVideoHeaderCellInSection:section++];
        [self initDescCellInSection:section++];
        if (1) {
            [self setHeaderHeight:kWidth(1) inSection:section];
            [self initPhotosCellInSection:section++];
        }
    } else {
        [self initImageTextCellInSection:section++];
        
    }

    [self setHeaderHeight:kWidth(20) inSection:section];
    [self initCommandCellInSection:section++];
    for (NSUInteger count = 0 ; count < 10; count++) {
        [self initCommandDetailsInSection:section++];
    }
    
    [self.layoutTableView reloadData];
}

#pragma mark - videoDetail

- (void)initVideoHeaderCellInSection:(NSUInteger)section {
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
    NSArray *array = @[@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg",@"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg"];
    _photosCell.dataSource = array;
    @weakify(self);
    _photosCell.selectedIndex = ^(NSNumber *index) {
        @strongify(self);
        if ([self->_messageView.textField isFirstResponder]) {
            [self->_messageView.textField resignFirstResponder];
            return ;
        }
        [self playPhotoUrlWithInfo:nil urlArray:array index:[index integerValue]];
    };
    
    [self setLayoutCell:_photosCell cellHeight:kWidth(290) inRow:0 andSection:section];
}

#pragma mark - image-text Detail

- (void)initImageTextCellInSection:(NSUInteger)section {
    _imgTextCell = [[LSJDetailImgTextHeaderCell alloc] init];
    _imgTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *titlestr = @"asdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasd";
    _imgTextCell.titleStr = @"asdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasdasdfsdfsdfsdfasdfasdfasd";
    _imgTextCell.timeStr = @"asdfsdfsdf";
    _imgTextCell.nameStr = @"asdfasdfsdf";
    
    CGFloat height = [titlestr sizeWithFont:[UIFont systemFontOfSize:kWidth(34)] maxSize:CGSizeMake(kScreenWidth - kWidth(64), MAXFLOAT)].height;
    
    [self setLayoutCell:_imgTextCell cellHeight:height + kWidth(90) inRow:0 andSection:section];
}


#pragma mark - common Detail

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
    
    _commandCell = [[LSJDetailVideoCommandCell alloc] init];
    _commandCell.userImgUrlStr = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg";
    _commandCell.userNameStr = @"花式撸炮";
    _commandCell.timeStr = @"asdasd";
    _commandCell.commandStr = str;
    
    [self setLayoutCell:_commandCell cellHeight:kWidth(140)+height inRow:0 andSection:section];
}
@end