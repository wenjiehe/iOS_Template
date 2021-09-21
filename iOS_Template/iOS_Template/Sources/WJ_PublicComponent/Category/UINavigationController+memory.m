//
//  UINavigationController+memory.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "UINavigationController+memory.h"
#import <objc/runtime.h>
#import "HHJAppManager.h"

@implementation UINavigationController (memory)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self vcSwizzleInstanceSel:NSSelectorFromString(@"dealloc") withNewSel:NSSelectorFromString(@"customNavDealloc")];
        [self vcSwizzleInstanceSel:NSSelectorFromString(@"pushViewController:animated:") withNewSel:NSSelectorFromString(@"customNavPushViewController:animated:")];
    });
}

+ (void)vcSwizzleInstanceSel:(SEL)oldSel withNewSel:(SEL)newSel {
    Class class = self.class;
    Method oldM = class_getInstanceMethod(class, oldSel);
    Method newM = class_getInstanceMethod(class, newSel);
    BOOL didAdd = class_addMethod(class, oldSel, method_getImplementation(newM), method_getTypeEncoding(newM));
    if (didAdd) {
        class_replaceMethod(class, newSel, method_getImplementation(oldM), method_getTypeEncoding(oldM));
    }else {
        method_exchangeImplementations(oldM, newM);
    }
}

#pragma mark -- 利用runtime实现记录哪些ViewController没有释放dealloc
- (void)customNavDealloc
{
    if ([[HHJAppManager sharedInstance].vcMtbAry containsObject:NSStringFromClass(self.class)]) {
        [[HHJAppManager sharedInstance].vcMtbAry removeObject:NSStringFromClass(self.class)];
    }
    [self customNavDealloc];
}

- (void)customNavPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[HHJAppManager sharedInstance].vcMtbAry addObject:NSStringFromClass(viewController.class)];
    [self customNavPushViewController:viewController animated:animated];
}

@end
