//
//  UIViewController+HHJMemory.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "UIViewController+HHJMemory.h"
#import <objc/runtime.h>
#import "HHJAppManager.h"

@implementation UIViewController (HHJMemory)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self vcSwizzleInstanceSel:NSSelectorFromString(@"dealloc") withNewSel:NSSelectorFromString(@"customVCDealloc")];
        [self vcSwizzleInstanceSel:NSSelectorFromString(@"customPresentViewController:animated:completion:") withNewSel:NSSelectorFromString(@"presentViewController:animated:completion:")];
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
- (void)customVCDealloc
{
    if ([[HHJAppManager sharedInstance].vcMtbAry containsObject:NSStringFromClass(self.class)]) {
        [[HHJAppManager sharedInstance].vcMtbAry removeObject:NSStringFromClass(self.class)];
    }
    [self customVCDealloc];
}

- (void)customPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [[HHJAppManager sharedInstance].vcMtbAry addObject:NSStringFromClass(viewControllerToPresent.class)];
    [self customPresentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
