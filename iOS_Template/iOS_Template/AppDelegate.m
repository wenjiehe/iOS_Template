//
//  AppDelegate.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/19.
//

#import "AppDelegate.h"
#import "HHJTabBarViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong)HHJTabBarViewController *tabbarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabbarVC = [[HHJTabBarViewController alloc] init];
    self.window.rootViewController = self.tabbarVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
