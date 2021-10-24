//
//  HHJHomeViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/22.
//

#import "HHJHomeViewController.h"
#import "HHJUtilService.h"
#import "HHJ_LoginService.h"
#import "HHJContext.h"
#import "HHJ_CameraService.h"
#import "HHJGlobalConstant.h"
#import "HHJAppManager.h"
#import "HHJ_RegisterService.h"
#import "HHJVideoUtils.h"
#import "HHJBaseModel.h"

@interface HHJHomeViewController ()

@end

@implementation HHJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"homeType = %@", self.homeType);
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.f green:(arc4random() % 255) / 255.f  blue:(arc4random() % 255) / 255.f alpha:1.f];
//    self.isHiddenTableView = YES; //隐藏tableview
    
    HHJBaseModel *model = [[HHJBaseModel alloc] init];

    model.dataDic = @{@"title" : @""};
    model.styleType = @"homeGrid";

    self.dataAry = @[model];
    [self reloadTableData];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([self.homeType isEqualToString:@"11"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];    
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.homeType isEqualToString:@"11"]) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    HHJLog(@"");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    HHJLog(@"viewControllers = %@", HHJContext.getCurrentVC.navigationController.viewControllers);
    
//    id<HHJ_LoginProtocol> loginService = [HHJContext findServerName:@"HHJ_LoginProtocol"];
//    [loginService startLogin:@{} animated:YES loginSuccess:^(NSDictionary * _Nonnull userInfo, NSDictionary * _Nonnull extendInfo) {
//
//    } pageProcessSuccess:^BOOL{
//        //说明登录流程已走完，执行下面的逻辑
//        id<HHJ_CameraProtocol> cameraService = [HHJContext findServerName:@"HHJ_CameraProtocol"];
//        [cameraService startQRCodeWithExtendInfo:@{} animated:YES completionHandle:^(NSString * _Nonnull qrcodeString, NSString * _Nonnull source, NSDictionary * _Nonnull extendInfo) {
//
//        }];
//        return NO;
//    }];

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
