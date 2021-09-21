//
//  HHJ_LoginService.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJ_LoginService.h"
#import "HHJLoginViewController.h"
#import "HHJContext.h"

@implementation HHJ_LoginService

- (void)startLogin:(NSDictionary *)extendInfo animated:(BOOL)animated loginSuccess:(void (^)(NSDictionary * _Nonnull, NSDictionary * _Nonnull))loginSuccess pageProcessSuccess:(BOOL (^)(void))pageProcessSuccess{
    HHJLoginViewController *login = [[HHJLoginViewController alloc] init];
    login.extendInfo = extendInfo;
    login.successBlock = loginSuccess;
    login.processBlock = pageProcessSuccess;
    if (HHJContext.getCurrentVC.navigationController) {
        [HHJContext.getCurrentVC.navigationController pushViewController:login animated:animated];
    }else{
        [HHJContext.getCurrentVC presentViewController:login animated:animated completion:^{
            
        }];
    }
}

- (void)cleanLoginInfo {
    
}



@end
