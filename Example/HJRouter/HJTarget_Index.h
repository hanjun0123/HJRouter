//
//  HJTarget_Index.h
//  HJRouter_Example
//
//  Created by hanjun on 2019/12/24.
//  Copyright © 2019 hanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJTarget_Index : NSObject

- (id)action_home:(NSDictionary *)param;

- (id)action_ui:(NSDictionary *)param;

- (id)action_setting:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
