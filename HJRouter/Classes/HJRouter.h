//  HJRouter.h
//  target-action 两个参数来确定target和action
//  Created by hanjun on 2018/4/18.
//  Copyright © 2018年 hanjun. All rights reserved.

#import <Foundation/Foundation.h>

@interface HJRouter : NSObject

+ (instancetype)sharedInstance;

- (id)openURL:(NSString *)urlString;

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)param;

@end
