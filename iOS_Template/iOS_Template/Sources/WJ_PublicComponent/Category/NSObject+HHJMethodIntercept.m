//
//  NSObject+HHJMethodIntercept.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "NSObject+HHJMethodIntercept.h"

@implementation NSObject (HHJMethodIntercept)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *className = NSStringFromClass([anInvocation.target class]);
    NSString *selectorName = NSStringFromSelector(anInvocation.selector);
    NSLog(@"类:%@中未实现该方法:%@", className, selectorName);
    //只针对协议服务类做处理，避免崩溃
    if ([className hasPrefix:@"HHJ_"] && [className hasSuffix:@"Service"]) {
        [self tempMethod];
    }
}

- (void)tempMethod{ //临时方法：为未实现方法转发，避免崩溃
    
}

@end
