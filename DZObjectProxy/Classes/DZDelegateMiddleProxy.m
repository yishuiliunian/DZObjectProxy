//
//  DZDelegateMiddleProxy.m
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import "DZDelegateMiddleProxy.h"

@implementation DZDelegateMiddleProxy

- (instancetype)initWithMiddleMan:(id)middleMan
{
    if (self)
    {
        _middleMan = middleMan;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)sel
{
    BOOL originalDelegateResponds = [self.originalDelegate respondsToSelector:sel];
    BOOL middleManResponds = [self.middleMan respondsToSelector:sel];
    if (originalDelegateResponds && !middleManResponds) {
        return self.originalDelegate;
    } else if (!originalDelegateResponds && middleManResponds) {
        return self.middleMan;
    } else {
        // continue with "slow" forwarding
        return self;
    }
}

- (NSInvocation *)_copyInvocation:(NSInvocation *)invocation
{
    NSInvocation *copy = [NSInvocation invocationWithMethodSignature:[invocation methodSignature]];
    NSUInteger argCount = [[invocation methodSignature] numberOfArguments];
    
    for (int i = 0; i < argCount; i++)
    {
        char buffer[sizeof(intmax_t)];
        [invocation getArgument:(void *)&buffer atIndex:i];
        [copy setArgument:(void *)&buffer atIndex:i];
    }
    
    return copy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.middleMan respondsToSelector:invocation.selector])
    {
        NSInvocation *invocationCopy = [self _copyInvocation:invocation];
        [invocationCopy invokeWithTarget:self.middleMan];
    }
    
    if ([self.originalDelegate respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:self.originalDelegate];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    id result = [self.originalDelegate methodSignatureForSelector:sel];
    if (!result) {
        result = [self.middleMan methodSignatureForSelector:sel];
    }
    
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([self.originalDelegate respondsToSelector:aSelector]
            || [self.middleMan respondsToSelector:aSelector]);
}
@end
