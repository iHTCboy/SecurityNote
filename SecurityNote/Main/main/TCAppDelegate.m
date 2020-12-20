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
#import "DYFAppLock.h"

@interface TCAppDelegate()

@property (nonatomic, assign) BOOL isLooked;

@end

@implementation TCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupUI];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = TCCoror(51, 149, 253);//[UIColor whiteColor];

    
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
    
    [self executeAuthentication];
    
    return YES;

}

- (void)setupUI {
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.tintColor = UIColor.whiteColor;
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    appearance.barTintColor = TCCoror(51, 149, 253);
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance * navBarAppearance = [UINavigationBarAppearance new];
        [navBarAppearance configureWithOpaqueBackground];
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        navBarAppearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        navBarAppearance.backgroundColor = TCCoror(51, 149, 253);
        appearance.standardAppearance = navBarAppearance;
        appearance.scrollEdgeAppearance = navBarAppearance;
    }
    
    [UIApplication.sharedApplication setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


- (void)executeAuthentication {
    
    if (self.isLooked) {
        return;
    }
    
    self.isLooked = YES;
    
    BOOL isAuthIDOpen      = [DYFSecurityHelper authIDOpen];
    BOOL isGestureCodeOpen = [DYFSecurityHelper gestureCodeOpen];
    if (!isAuthIDOpen && !isGestureCodeOpen) {
        return;
    }
    
    DYFAuthenticationType type = DYFAuthenticationTypeGesture;
    if (isAuthIDOpen) {
        type = DYFAuthenticationTypeAuthID;
    }
    
    DYFAuthenticationView *authView = [[DYFAuthenticationView alloc] initWithFrame:[UIScreen mainScreen].bounds authenticationType:type];
    authView.avatarImage = [self getAvatarImage];
    [authView show];
    
    [authView authenticateWithCompletion:^(BOOL success) {
        if (success) {
            // 进行相应的操作
//            NSLog(@"验证成功");
            self.isLooked = NO;
        }
    }];
    
}


- (UIImage *)getAvatarImage {
    /*读取入图片*/
    //Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    //因为拿到的是个路径，所以把它加载成一个data对象
    NSData *data=[NSData dataWithContentsOfFile:uniquePath];
    
    //判断是否存储照片，如果没有就用默认
    if (data)
    {
        //把该图片读出来
        UIImage * image = [UIImage imageWithData:data];
        //CGFloat min = MIN(image.size.width, image.size.height);
        return image;
    }
    
    return [UIImage imageNamed:@"cluck.jpg"];
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
    [statTracker logEvent:@"AppName" eventLabel:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]];
#endif
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self executeAuthentication];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self executeAuthentication];
}

@end
