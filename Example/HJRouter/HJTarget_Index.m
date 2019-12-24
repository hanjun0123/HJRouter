//
//  HJTarget_Index.m
//  HJRouter_Example
//
//  Created by hanjun on 2019/12/24.
//  Copyright © 2019 hanjun. All rights reserved.
//

#import "HJTarget_Index.h"
#import "HJHomeViewController.h"
#import "HJUIViewController.h"
#import "HJSettingViewController.h"

@implementation HJTarget_Index

- (id)action_home:(NSDictionary *)param{
    HJHomeViewController * vc = [[HJHomeViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

- (id)action_ui:(NSDictionary *)param {
    HJUIViewController * vc = [[HJUIViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

- (id)action_setting:(NSDictionary *)param{
    HJSettingViewController * vc = [[HJSettingViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}


@end
