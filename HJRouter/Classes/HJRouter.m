
//  HJRouter.m
//
//  Created by hanjun on 2018/4/18.
//  Copyright © 2018年 hanjun. All rights reserved.

#import "HJRouter.h"

@implementation HJRouter

+ (instancetype)sharedInstance{
    static HJRouter * mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HJRouter alloc] init];
    });
    return mediator;
}

- (id)openURL:(NSString *)urlString{
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    NSString * urlStr = [url query];
    for (NSString * param in [urlStr componentsSeparatedByString:@"&"]) {
        NSArray * elts = [param componentsSeparatedByString:@"="];
        if ([elts count]<2) {
            continue;
        }
        id fristEle = [elts firstObject];
        id lastEle = [elts lastObject];
        if (fristEle && lastEle) {
            [params setObject:lastEle forKey:fristEle];
        }
    }
    NSString * actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName param:params];
    return result;
}

- (id)openURL:(NSString *)urlString completion:(void (^)(id result))completion{
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    NSString * urlStr = [url query];
    for (NSString * param in [urlStr componentsSeparatedByString:@"&"]) {
        NSArray * elts = [param componentsSeparatedByString:@"="];
        if ([elts count]<2) {
            continue;
        }
        id fristEle = [elts firstObject];
        id lastEle = [elts lastObject];
        if (fristEle && lastEle) {
            [params setObject:lastEle forKey:fristEle];
        }
    }
    NSString * actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName param:params completion:completion];
    return result;

}

- (id)openURL:(NSString *)urlString body:(NSDictionary *)body completion:(void (^)(id result))completion{
    NSURL * url = [NSURL URLWithString:urlString];
    NSString * actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName body:body completion:completion];
       return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)param{
    //这个目标的类名字符串
    NSString * targetClassString = [NSString stringWithFormat:@"HJTarget_%@", targetName];
    NSString * actionMethodString = [NSString stringWithFormat:@"action_%@:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    NSObject * target = [[targetClass alloc] init];
    
    SEL action = NSSelectorFromString(actionMethodString);
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target param:param];
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target param:param];
        } else {
            return nil;
        }
    }
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target param:(NSDictionary *)param{
    NSMethodSignature * methodSign = [target methodSignatureForSelector:action];
    if (methodSign == nil) {
        return nil;
    }
    
    const char * retType = [methodSign methodReturnType];//获取这个方法返回值的地址
    //id 是可以返回任意对象，所以我们单独处理基本变量，NSInteger Bool Void...
    if (strcmp(retType, @encode(NSInteger))==0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        
        [invocation setArgument:&param atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        [invocation setArgument:&param atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:param];
    #pragma clang diagnostic pop
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)param completion:(void (^)(id result))completion{
    //这个目标的类名字符串
    NSString * targetClassString = [NSString stringWithFormat:@"HJTarget_%@", targetName];
    NSString * actionMethodString = [NSString stringWithFormat:@"action_%@:completion:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    NSObject * target = [[targetClass alloc] init];
    
    SEL action = NSSelectorFromString(actionMethodString);
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target param:param completion:completion];
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target param:param completion:completion];
        } else {
            return nil;
        }
    }
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target param:(NSDictionary *)param completion:(void (^)(id result))completion{
    NSMethodSignature * methodSign = [target methodSignatureForSelector:action];
    if (methodSign == nil) {
        return nil;
    }
    
    const char * retType = [methodSign methodReturnType];//获取这个方法返回值的地址
    //id 是可以返回任意对象，所以我们单独处理基本变量，NSInteger Bool Void...
    if (strcmp(retType, @encode(NSInteger))==0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        
        [invocation setArgument:&param atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setArgument:&completion atIndex:3];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        [invocation setArgument:&param atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setArgument:&completion atIndex:3];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:param withObject:completion];
    #pragma clang diagnostic pop
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName body:(NSDictionary *)body completion:(void (^)(id result))completion{
    //这个目标的类名字符串
    NSString * targetClassString = [NSString stringWithFormat:@"HJTarget_%@", targetName];
    NSString * actionMethodString = [NSString stringWithFormat:@"action_%@:completion:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    NSObject * target = [[targetClass alloc] init];
    
    SEL action = NSSelectorFromString(actionMethodString);
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target body:body completion:completion];
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target body:body completion:completion];
        } else {
            return nil;
        }
    }
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target body:(NSDictionary *)body completion:(void (^)(id result))completion{
    NSMethodSignature * methodSign = [target methodSignatureForSelector:action];
    if (methodSign == nil) {
        return nil;
    }
    
    const char * retType = [methodSign methodReturnType];//获取这个方法返回值的地址
    //id 是可以返回任意对象，所以我们单独处理基本变量，NSInteger Bool Void...
    if (strcmp(retType, @encode(NSInteger))==0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        [invocation setArgument:&body atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setArgument:&completion atIndex:3];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        [invocation setArgument:&body atIndex:2];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setArgument:&completion atIndex:3];//为什么传2？前面0和1这两个位置已经被target和action占用了
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation invoke];
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:body withObject:completion];
    #pragma clang diagnostic pop
}


@end
