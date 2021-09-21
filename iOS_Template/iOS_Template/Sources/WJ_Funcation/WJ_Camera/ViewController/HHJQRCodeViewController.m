//
//  HHJQRCodeViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJQRCodeViewController.h"
#import "HHJContext.h"
#import "HHJGlobalConstant.h"

@interface HHJQRCodeViewController ()

@end

@implementation HHJQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    HHJLog(@"viewControllers = %@", HHJContext.getCurrentVC.navigationController.viewControllers);
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
