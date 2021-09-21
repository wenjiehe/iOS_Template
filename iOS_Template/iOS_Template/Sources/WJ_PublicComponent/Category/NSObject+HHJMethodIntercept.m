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
    NSLog(@"类:%@中未实现该方法:%@", NSStringFromClass([anInvocation.target class]), NSStringFromSelector(anInvocation.selector));
    [self tempMethod];
}

- (void)tempMethod{ //临时方法：为未实现方法转发，避免崩溃
    
}

@end
