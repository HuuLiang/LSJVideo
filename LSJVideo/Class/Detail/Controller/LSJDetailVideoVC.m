//
//  LSJDetailVideoVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoVC.h"
#import "LSJDetailModel.h"

#import "LSJDetailTagModel.h"

#import "LSJDetailVideoHeaderCell.h"
#import "LSJDetailVideoDescCell.h"
#import "LSJDetailVideoPhotosCell.h"

#import "LSJDetailImgTextHeaderCell.h"
#import "LSJDetailImgTextCell.h"

#import "LSJDetailVideoCommandCell.h"

#import "LSJReportView.h"

@interface LSJDetailVideoVC ()
{
    NSInteger _columnId;
    LSJProgramModel * _programModel;
    
    LSJDetailVideoHeaderCell * _headerCell;
    LSJDetailVideoDescCell  * _descCell;
    LSJDetailVideoPhotosCell *_photosCell;
    
    LSJDetailImgTextHeaderCell *_imgTextHeaderCell;
    
    LSJDetailVideoCommandCell *_commandCell;
    
    LSJReportView *_reportView;
    LSJMessageView *_messageView;
    
}
@property (nonatomic) LSJDetailModel *detailModel;
@property (nonatomic) LSJDetailResponse *response;
@end

@implementation LSJDetailVideoVC
QBDefineLazyPropertyInitialization(LSJDetailModel, detailModel)
QBDefineLazyPropertyInitialization(LSJDetailResponse, response)

- (instancetype)initWithColumnId:(NSInteger)columnId Program:(LSJProgramModel *)program
{
    self = [super init];
    if (self) {
        _columnId = columnId;
        _programModel = program;
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
            LSJBaseModel *model = [[LSJBaseModel alloc] init];
            
            [self payWithBaseModelInfo:model];
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
            [self playVideoWithUrl:self.response.program.videoUrl
                         baseModel:[LSJBaseModel createModelWithProgramId:@1
                                                              ProgramType:@1
                                                             RealColumnId:@1
                                                              ChannelType:@1
                                                           PrgramLocation:1
                                                                     Spec:1]];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = _programModel.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    
    
    @weakify(self);
    [self.detailModel fetchProgramDetailInfoWithColumnId:_columnId ProgramId:_programModel.programId isImageText:_programModel.type == 4 CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            self.response = obj;
            [self.layoutTableView LSJ_endPullToRefresh];
            [self initCells];
        }
    
    }];
}

- (void)initCells {
    NSUInteger section = 0;
    
    if (_programModel.type == 1) {
        [self initVideoHeaderCellInSection:section++];
        [self initDescCellInSection:section++];
        if (self.response.programUrlList.count > 0) {
            [self setHeaderHeight:kWidth(1) inSection:section];
            [self initPhotosCellInSection:section++];
        }
    } else if (_programModel.type == 4) {
        [self initImageTextHeaderCellInSection:section++];
        if (self.response.programUrlList > 0) {
            for (LSJProgramUrlModel *urlModel in self.response.programUrlList) {
                [self initImageTextCellInSection:section++ programUrlModel:urlModel];
            }
        }
    }

    [self setHeaderHeight:kWidth(20) inSection:section];
    
    if (self.response.commentJson.count > 0) {
        [self initCommandCellInSection:section++];
        for (NSUInteger count = 0 ; count < self.response.commentJson.count; count++) {
            LSJCommentModel *commentModel = self.response.commentJson[count];
            [self initCommandDetailsInSection:section++ comment:commentModel];
        }
    }

    [self.layoutTableView reloadData];
}

#pragma mark - videoDetail

- (void)initVideoHeaderCellInSection:(NSUInteger)section {
    _headerCell = [[LSJDetailVideoHeaderCell alloc] init];
    _headerCell.imgUrlStr = self.response.program.coverImg;
    [self setLayoutCell:_headerCell cellHeight:kScreenWidth * 0.6 inRow:0 andSection:section];
}

- (void)initDescCellInSection:(NSUInteger)section {
    _descCell = [[LSJDetailVideoDescCell alloc] init];
    _descCell.titleStr = self.response.program.title;
    _descCell.countStr = self.response.program.specialDesc;
    NSDictionary *dicA = [LSJDetailTagModel randomCountFirst];
    NSDictionary *dicB = [LSJDetailTagModel randomCountSecond:dicA];
    _descCell.tagAStr = dicA[@"title"];
    _descCell.tagBStr = dicB[@"title"];
    _descCell.tagAColor = [UIColor colorWithHexString:dicA[@"color"]];
    _descCell.tagBColor = [UIColor colorWithHexString:dicB[@"color"]];
    [self setLayoutCell:_descCell cellHeight:kWidth(140) inRow:0 andSection:section];
}

- (void)initPhotosCellInSection:(NSUInteger)section {
    _photosCell = [[LSJDetailVideoPhotosCell alloc] init];
    NSArray *array = self.response.programUrlList;
    _photosCell.dataSource = array;
    @weakify(self);
    _photosCell.selectedIndex = ^(NSNumber *index) {
        @strongify(self);
        if ([self->_messageView.textField isFirstResponder]) {
            [self->_messageView.textField resignFirstResponder];
            return ;
        }
        
        [self playPhotoUrlWithModel:[LSJBaseModel createModelWithProgramId:@1
                                                               ProgramType:@1
                                                              RealColumnId:@1
                                                               ChannelType:@1
                                                            PrgramLocation:1
                                                                      Spec:1]
                           urlArray:array
                              index:[index integerValue]];
    };
    
    [self setLayoutCell:_photosCell cellHeight:kWidth(290) inRow:0 andSection:section];
}

#pragma mark - image-text Detail

- (void)initImageTextHeaderCellInSection:(NSUInteger)section {
    _imgTextHeaderCell = [[LSJDetailImgTextHeaderCell alloc] init];
    _imgTextHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *titlestr = self.response.program.title;
    _imgTextHeaderCell.titleStr = titlestr;
    _imgTextHeaderCell.timeStr = _programModel.spare;
    _imgTextHeaderCell.nameStr = self.response.program.userName;
    
    CGFloat height = [titlestr sizeWithFont:[UIFont systemFontOfSize:kWidth(34)] maxSize:CGSizeMake(kScreenWidth - kWidth(64), MAXFLOAT)].height;
    
    [self setLayoutCell:_imgTextHeaderCell cellHeight:height + kWidth(90) inRow:0 andSection:section];
}

- (void)initImageTextCellInSection:(NSUInteger)section programUrlModel:(LSJProgramUrlModel *)model {
    LSJDetailImgTextCell *_imgTextCell = [[LSJDetailImgTextCell alloc] initWithContentType:model.type];
    CGFloat height = 0;
    if (model.type == LSJContentType_Text) {
        height = [model.content sizeWithFont:[UIFont systemFontOfSize:kWidth(30)] maxSize:CGSizeMake(kScreenWidth - kWidth(60), MAXFLOAT)].height + kWidth(15);
    } else if (model.type == LSJContentType_Image) {
        height = (kScreenWidth - kWidth(60)) * 0.6 + kWidth(15);
    }
    _imgTextCell.content = model.content;
    [self setLayoutCell:_imgTextCell cellHeight:height inRow:0 andSection:section];
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

- (void)initCommandDetailsInSection:(NSUInteger)section comment:(LSJCommentModel *)comment {
    [self setHeaderHeight:kWidth(1) inSection:section];
    NSString *str = comment.content;
    CGFloat height = [str sizeWithFont:[UIFont systemFontOfSize:kWidth(30)] maxSize:CGSizeMake(kScreenWidth - kWidth(60), MAXFLOAT)].height;
    
    _commandCell = [[LSJDetailVideoCommandCell alloc] init];
    _commandCell.userImgUrlStr = comment.icon;
    _commandCell.userNameStr = comment.userName;
    _commandCell.timeStr = comment.createAt;
    _commandCell.commandStr = str;
    
    [self setLayoutCell:_commandCell cellHeight:kWidth(140)+height inRow:0 andSection:section];
}
@end
