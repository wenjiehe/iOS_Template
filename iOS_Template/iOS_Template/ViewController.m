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
#import "HHJQRCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"进来了");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    id<HHJ_LoginProtocol> loginService = [HHJContext findServerName:@"HHJ_LoginProtocol"];
    [loginService startLogin:@{} animated:YES loginSuccess:^(NSDictionary * _Nonnull userInfo, NSDictionary * _Nonnull extendInfo) {
        
    } pageProcessSuccess:^BOOL{
        //说明登录流程已走完，执行下面的逻辑
        HHJQRCodeViewController *qrcodeVC = [[HHJQRCodeViewController alloc] init];
        [HHJContext.getCurrentVC.navigationController pushViewController:qrcodeVC animated:YES];
        return NO;
    }];
}

@end
