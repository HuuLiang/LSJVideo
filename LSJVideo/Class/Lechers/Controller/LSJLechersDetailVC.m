//
//  LSJLechersDetailVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersDetailVC.h"
#import "LSJProgramConfigModel.h"
#import "LSJLecherProgramCell.h"

static NSString * const kLecherProgramCellReusableIdentifier = @"kLecherProgramCellReusableIdentifier";

@interface LSJLechersDetailVC () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) LSJColumnModel *columnModel;
@property (nonatomic) LSJProgramConfigModel *programModel;
@end

@implementation LSJLechersDetailVC
QBDefineLazyPropertyInitialization(LSJColumnModel, columnModel)
QBDefineLazyPropertyInitialization(LSJProgramConfigModel, programModel)


- (instancetype)initWithColumn:(LSJColumnModel *)column
{
    self = [super init];
    if (self) {
        _columnModel = column;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.title = _columnModel.name;
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = [UIColor clearColor];
    [_layoutTableView registerClass:[LSJLecherProgramCell class] forCellReuseIdentifier:kLecherProgramCellReusableIdentifier];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_layoutTableView];
    
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    
    [_layoutTableView LSJ_triggerPullToRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self.programModel fetchProgramsInfoWithColumnId:_columnModel.columnId IsProgram:YES CompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        if (success) {
            _columnModel = obj;
            [_layoutTableView LSJ_endPullToRefresh];
            [_layoutTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _columnModel.programList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJLecherProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:kLecherProgramCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < _columnModel.programList.count) {
        LSJProgramModel * program = _columnModel.programList[indexPath.row];
        cell.bgImgUrlStr = program.coverImg;
        cell.userImgUrlStr = program.icon;
        cell.userNameStr = program.userName;
        cell.titleStr = program.title;
        cell.timeStr = program.createAt;
        cell.commandCount = program.commentNum;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _columnModel.programList.count - 1) {
//        DLog(@"%ld %@",indexPath.row ,@210);
//        return kWidth(210);
//    } else {
//        DLog(@"%ld %@",indexPath.row ,@226);
        return kWidth(226);
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _columnModel.programList.count) {
        LSJProgramModel * program = _columnModel.programList[indexPath.row];
        LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(_columnModel.realColumnId) ChannelType:@(_columnModel.type) PrgramLocation:indexPath.row Spec:NSNotFound subTab:self.currentIndex];
        [self pushToDetailVideoWithController:self ColumnId:_columnModel.columnId program:program baseModel:baseModel];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:self.currentIndex forSlideCount:1];
}
@end
