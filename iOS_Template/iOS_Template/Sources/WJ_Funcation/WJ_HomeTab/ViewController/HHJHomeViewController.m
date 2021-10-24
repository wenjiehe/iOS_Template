//
//  HHJHomeViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/22.
//

#import "HHJHomeViewController.h"

@interface HHJHomeViewController ()

@end

@implementation HHJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"homeType = %@", self.homeType);
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.f green:(arc4random() % 255) / 255.f  blue:(arc4random() % 255) / 255.f alpha:1.f];
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
