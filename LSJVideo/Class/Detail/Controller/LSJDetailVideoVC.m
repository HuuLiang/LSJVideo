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

#import "LSJBtnView.h"
@interface LSJDetailVideoVC ()
{
    NSInteger _columnId;
    LSJProgramModel * _programModel;
    
    LSJDetailVideoHeaderCell * _headerCell;
    LSJDetailVideoDescCell  * _descCell;
    LSJDetailVideoPhotosCell *_photosCell;
    
    LSJDetailImgTextHeaderCell *_imgTextHeaderCell;
    UITableViewCell *_imageVipCell;
    
    LSJDetailVideoCommandCell *_commandCell;
    
    LSJReportView *_reportView;
    LSJMessageView *_messageView;
    
    LSJBtnView *_btnView;
}
@property (nonatomic) LSJDetailModel *detailModel;
@property (nonatomic) LSJDetailResponse *response;
@property (nonatomic) LSJBaseModel *baseModel;
@end

@implementation LSJDetailVideoVC
QBDefineLazyPropertyInitialization(LSJDetailModel, detailModel)
QBDefineLazyPropertyInitialization(LSJDetailResponse, response)

- (instancetype)initWithColumnId:(NSInteger)columnId Program:(LSJProgramModel *)program baseModel:(LSJBaseModel *)baseModel
{
    self = [super init];
    if (self) {
        _columnId = columnId;
        _programModel = program;
        _baseModel = baseModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.hasRowSeparator = NO;
    
    
    _messageView = [[LSJMessageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-64, kScreenWidth, kWidth(210))];
    [self.view addSubview:_messageView];
    
    [_messageView.sendBtn bk_addEventHandler:^(id sender) {
        [_messageView.textView becomeFirstResponder];
        if ([LSJUtil isVip]) {
            if (_messageView.textView.text.length < 1) {
                [[CRKHudManager manager] showHudWithText:@"您输入的评论过短"];
            } else {
                [[CRKHudManager manager] showHudWithText:@"请等待审核"];
                _messageView.textView.text = @"";
                [_messageView.textView resignFirstResponder];
            }
        } else {
            [[CRKHudManager manager] showHudWithText:@"非VIP用户不可发表评论"];
            _messageView.textView.text = @"";
            [_messageView.textView resignFirstResponder];            
            [self payWithBaseModelInfo:_baseModel];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _reportView = [[LSJReportView alloc] init];
    @weakify(self);
    _reportView.popKeyboard = ^{
        @strongify(self);
        [self->_messageView.textView becomeFirstResponder];
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
        if ([self->_messageView.textView isFirstResponder]) {
            [self->_messageView.textView resignFirstResponder];
            return ;
        }
        if (cell == self->_headerCell) {
            [self playVideoWithUrl:self.response.program.videoUrl
                         baseModel:self.baseModel];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kPaidNotificationName object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaidNotificationName object:nil];
}

- (void)refreshView {
    [self.layoutTableView LSJ_triggerPullToRefresh];
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
            NSInteger count = 0;
            for (LSJProgramUrlModel *urlModel in self.response.programUrlList) {
                if (count == 3 && ![LSJUtil isVip]) {
                    [self initImageVipNotiCellInSection:section++];
                    break;
                }
                [self initImageTextCellInSection:section++ programUrlModel:urlModel];
                count++;
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
    _headerCell.imgUrlStr = self.response.program.detailsCoverImg;
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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (LSJProgramUrlModel *model in self.response.programUrlList) {
        [array addObject:model.url];
    }
    _photosCell.dataSource = self.response.programUrlList;
    @weakify(self);
    _photosCell.selectedIndex = ^(NSNumber *index) {
        @strongify(self);
        if ([self->_messageView.textView isFirstResponder]) {
            [self->_messageView.textView resignFirstResponder];
            return ;
        }

        [self playPhotoUrlWithModel:self.baseModel
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

- (void)initImageVipNotiCellInSection:(NSUInteger)section {
    _imageVipCell = [[UITableViewCell alloc] init];
    _imageVipCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _imageVipCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    @weakify(self);
    _btnView = [[LSJBtnView alloc] initWithNormalTitle:@"点击查看全文" selectedTitle:@"点击查看全文" normalImage:[UIImage imageNamed:@"detail_all"] selectedImage:[UIImage imageNamed:@"detail_all"] space:kWidth(15) isTitleFirst:NO touchAction:^{
        @strongify(self);
        [self payWithBaseModelInfo:self.baseModel];
    }];
    _btnView.titleLabel.textColor = [UIColor colorWithHexString:@"#0876f6"];
    _btnView.titleLabel.font = [UIFont systemFontOfSize:kWidth(36)];
    [_imageVipCell addSubview:_btnView];
    {
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageVipCell);
            make.centerY.equalTo(_imageVipCell.mas_centerY).offset(-kWidth(10));
            make.size.mas_equalTo(CGSizeMake(kWidth(270), kWidth(60)));
        }];
    }
    
    [self setLayoutCell:_imageVipCell cellHeight:kWidth(100) inRow:0 andSection:section];
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
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = kWidth(7);
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(36)],
                            NSParagraphStyleAttributeName:style};
    CGFloat height = [str sizeAndLineSpaceWithFont:[UIFont systemFontOfSize:kWidth(36)] maxSize:CGSizeMake(kScreenWidth - kWidth(143), MAXFLOAT) attrs:attrs].height;
    
    NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:str attributes:attrs];
    
    _commandCell = [[LSJDetailVideoCommandCell alloc] init];
    _commandCell.userImgUrlStr = comment.icon;
    _commandCell.userNameStr = comment.userName;
    _commandCell.timeStr = comment.createAt;
    _commandCell.commandAttriStr = attriStr;
    
    [self setLayoutCell:_commandCell cellHeight:kWidth(152)+height inRow:0 andSection:section];
}
@end
