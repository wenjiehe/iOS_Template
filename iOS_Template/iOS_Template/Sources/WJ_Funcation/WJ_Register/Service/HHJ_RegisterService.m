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
    [HHJContext.getCurrentVC.navigationController pushViewController:registerVC animated:YES];
}

@end
