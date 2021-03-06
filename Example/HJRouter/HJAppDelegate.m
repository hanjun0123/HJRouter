//
//  HJAppDelegate.m
//  HJRouter
//
//  Created by hanjun on 12/24/2019.
//  Copyright (c) 2019 hanjun. All rights reserved.
//

#import "HJAppDelegate.h"
#import "HJRouter.h"

@implementation HJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UINavigationController * homeNav = [[HJRouter sharedInstance] openURL:@"http://Index/home?p1=x&p2=2"];
    UINavigationController * uiNav = [[HJRouter sharedInstance] openURL:@"http://Index/ui?b1=x&b2=2" completion:^(NSString * result) {
        NSLog(@"result = %@", result);
    }];
    
    NSDictionary *body = @{@"x":@"x1",@"y":@"y1"};
    UINavigationController * settingNav = [[HJRouter sharedInstance] openURL:@"http://Index/setting" body:body completion:^(NSString * result) {
        NSLog(@"result = %@", result);
    }];
    UITabBarController * tabC = [[UITabBarController alloc] init];
    [tabC setViewControllers:@[homeNav, uiNav, settingNav]];
     
    self.window.rootViewController = tabC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
