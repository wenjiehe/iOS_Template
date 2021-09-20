//
//  ViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/19.
//

#import "ViewController.h"
#import "HHJUtilService.h"

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
    [HHJUtilService getNetworkStatus:^(NSString * _Nonnull status) {
        NSLog(@"status = %@", status);
    }];
}

@end
