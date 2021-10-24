//
//  ViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/19.
//

#import "ViewController.h"
#import "HHJUtilService.h"
#import "HHJ_LoginService.h"
#import "HHJContext.h"
#import "HHJ_CameraService.h"
#import "HHJGlobalConstant.h"
#import "HHJAppManager.h"
#import "HHJ_RegisterService.h"
#import "HHJVideoUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

@end
