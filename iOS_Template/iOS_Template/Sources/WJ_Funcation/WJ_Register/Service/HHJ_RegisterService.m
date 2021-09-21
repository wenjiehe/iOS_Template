//
//  HHJ_RegisterService.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJ_RegisterService.h"
#import "HHJRegisterViewController.h"
#import "HHJContext.h"

@implementation HHJ_RegisterService

- (void)startRegister{
    HHJRegisterViewController *registerVC = [[HHJRegisterViewController alloc] init];
    if (HHJContext.getCurrentVC.navigationController) {
        [HHJContext.getCurrentVC.navigationController pushViewController:registerVC animated:YES];
    }else{
        [HHJContext.getCurrentVC presentViewController:registerVC animated:YES completion:^{
            
        }];
    }
}

@end
