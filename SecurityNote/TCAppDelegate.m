//
//  TCAppDelegate.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-11.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCAppDelegate.h"
#import "TCShowViewController.h"
#import "BaiduMobStat.h"
#import "DHDeviceUtil.h"

@implementation TCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
//    NSString *key = @"CFBundleShortVersionString";
//    
//    // 取出沙盒中存储的上次使用软件的版本号
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *lastVersion = [defaults stringForKey:key];
//    
//    // 获得当前软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    //旧版本
//    if ([currentVersion isEqualToString:lastVersion])
//    {
        // 从故事版中加载
        UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [stryBoard instantiateInitialViewController];
        
//    }
//    else
//    { // 新版本
//        self.window.rootViewController = [[TCShowViewController alloc]init];
//        
//        // 存储新版本
//        [defaults setObject:currentVersion forKey:key];
//        [defaults synchronize];
//    }
    
    
#ifdef DEBUG
    
#else
    [self startBaiduMobStat];
#endif
    
    
    [self.window makeKeyAndVisible];
    return YES;

}


/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"96b7742677"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    // 其它事件
    [statTracker logEvent:@"usermodelName" eventLabel:[DHDeviceUtil deviceModelName]];
    [statTracker logEvent:@"systemVersion" eventLabel:[UIDevice currentDevice].systemVersion];
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
