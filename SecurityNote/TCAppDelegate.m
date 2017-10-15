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
#if DEBUG
    NSLog(@"Debug Model");
#else
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale currentLocale];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *currentDate = [df stringFromDate:[NSDate new]];
    
    // 自定义事件
    [statTracker logEvent:@"usermodelName" eventLabel:[DHDeviceUtil deviceModelName]];
    [statTracker logEvent:@"systemVersion" eventLabel:[[UIDevice currentDevice] systemVersion]];
    [statTracker logEvent:@"Devices" eventLabel:[[UIDevice currentDevice] name]];
    [statTracker logEvent:@"DateAndDeviceName" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] name]]];
    [statTracker logEvent:@"DateSystemVersion" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] systemVersion]]];
#endif
}

@end
