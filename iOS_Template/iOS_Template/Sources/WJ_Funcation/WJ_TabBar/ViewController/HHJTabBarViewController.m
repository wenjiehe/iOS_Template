//
//  HHJTabBarViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJTabBarViewController.h"
#import "HHJHomeViewController.h"
#import "HHJCustomTabBarView.h"
#import "HHJGlobalConstant.h"
#import "HHJHomeNavigationController.h"

@interface HHJTabBarViewController ()<HHJCustomTabBarViewDelegate, UITabBarControllerDelegate>

@property(nonatomic,strong)HHJCustomTabBarView *ctbView;
@property(nonatomic,strong)NSMutableArray *mtbAry;

@end

@implementation HHJTabBarViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)initUI{
    self.tabBar.hidden = YES;

    self.ctbView = [[HHJCustomTabBarView alloc] initWithFrame:CGRectMake(0, screenHeight - kTabBarHeight - kTitleHeight, screenWidth, kTabBarHeight)];
    self.ctbView.delegate = self;
    [self.view addSubview:self.ctbView];
    
    self.mtbAry = [NSMutableArray new];
    NSArray *typeAry = @[@"11", @"12", @"13", @"14", @"15"];
    NSArray *titleAry = @[@"首页", @"社区", @"消息", @"生活", @"我的"];
    for (NSInteger i = 0; i < typeAry.count; i++) {
        
        HHJHomeViewController *homeVC = [[HHJHomeViewController alloc] init];
        homeVC.homeType = typeAry[i];
        homeVC.title = titleAry[i];
        
        HHJHomeNavigationController *hnC = [[HHJHomeNavigationController alloc] initWithRootViewController:homeVC];

        [self.mtbAry addObject:hnC];
    }
    
    self.viewControllers = self.mtbAry;
    self.selectedIndex = 0;

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    self.selectedIndex = index;
    self.navigationItem.titleView = viewController.navigationItem.titleView;
    self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}



#pragma mark -- HHJCustomTabBarViewDelegate
- (void)didSelectIcon:(NSInteger)index{
    self.selectedIndex = index;
}

#pragma mark - 旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
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
