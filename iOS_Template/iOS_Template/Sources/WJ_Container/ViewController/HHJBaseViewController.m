//
//  HHJBaseViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJBaseViewController.h"
#import "HHJGlobalConstant.h"
#import "HHJBaseTableViewCell.h"
#import "HHJBaseModel.h"
#import "HHJTemplateManager.h"

@interface HHJBaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *idMtbAry;

@end

@implementation HHJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    _dataAry = [NSArray new];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [HHJTemplateManager shareInstance].templeteJumpEvent = ^(HHJBaseModel * _Nonnull model, NSInteger index, NSDictionary * _Nonnull extendInfo) {
        //响应点击事件
        HHJBaseModel *mod = [[HHJBaseModel alloc] init];
    
        mod.dataDic = @{@"title" : @"suib亲爱"};
        mod.styleType = @"homeGrid";
    
        self.dataAry = @[mod];
        [self reloadTableData];
    };
}

- (void)setDataAry:(NSArray *)dataAry{
    _dataAry = dataAry;
}

- (void)setIsHiddenTableView:(BOOL)isHiddenTableView{
    _isHiddenTableView = isHiddenTableView;
    if (_isHiddenTableView) {
        [self.tableView removeFromSuperview];
    }
}

- (void)reloadTableData{
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataAry.count > 0) {
        return self.dataAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHJBaseModel *model = self.dataAry[indexPath.row];
    NSString *identifer = [NSString stringWithFormat:@"HHJBaseTableViewCell%@",kCheckNil(model.styleType)];
    HHJBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[HHJBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.hhj_customModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHJBaseModel *model = self.dataAry[indexPath.row];
    CGFloat height = model.height.floatValue;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];//解决tabview顶部有一条线的问题
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];//解决tabview底部有一条线的问题
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"------------------------%ld",indexPath.row);
}


#pragma mark -- setter && getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        float topH = 0;
//        _tableView.contentInset = UIEdgeInsetsMake(topH, 0, kTabBarHeight, 0);
        if (@available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0) {//刘海屏
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 98, 0);
        }else {//非刘海屏
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 84, 0);
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray *)idMtbAry{
    if (!_idMtbAry) {
        _idMtbAry = [NSMutableArray new];
    }
    return _idMtbAry;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
