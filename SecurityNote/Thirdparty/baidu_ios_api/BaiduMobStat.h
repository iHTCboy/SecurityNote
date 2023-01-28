//
//  BaiduMobStat.h
//  BaiduMobStat
//
//  Created by Lidongdong on 15/7/22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifdef __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 日志发送策略
 */
typedef enum _BaiduMobStatLogStrategy {
    BaiduMobStatLogStrategyAppLaunch = 0,   //每次程序启动时发送（默认策略，推荐使用!）
} BaiduMobStatLogStrategy;

/**
 推送平台定义
 */
typedef enum _BaiduMobStatPushPlatform{
    BaiduMobStatPushPlatformBaiduCloud = 0, //百度云推送平台
    BaiduMobStatPushPlatformJiGuang = 1,    //极光推送平台
    BaiduMobStatPushPlatformGeTui = 2,      //个推推送平台
    BaiduMobStatPushPlatformUmeng = 5,      //友盟推送平台
    BaiduMobStatPushPlatformXinGe = 6,      //信鸽推送平台
    BaiduMobStatPushPlatformAliYun = 7,     //阿里云推送平台
} BaiduMobStatPushPlatform;

/**
 信息流监控策略
 */
typedef enum _BaiduMobStatFeedTrackStrategy {
    BaiduMobStatFeedTrackStrategyAll = 0,       //全部监控
    BaiduMobStatFeedTrackStrategySingle = 1,    //单个监控，需要监控的tableviw需要设置enableListTrack属性为YES
    BaiduMobStatFeedTrackStrategyNone = 2,      //关闭feed监控，不监控任何列表
} BaiduMobStatFeedTrackStrategy;

/**
 全局扩展信息
 */
@interface BaiduMobStatExtraInfo : NSObject
@property (nonatomic, copy, nullable) NSString* v1;
@property (nonatomic, copy, nullable) NSString* v2;
@property (nonatomic, copy, nullable) NSString* v3;
@property (nonatomic, copy, nullable) NSString* v4;
@property (nonatomic, copy, nullable) NSString* v5;
@property (nonatomic, copy, nullable) NSString* v6;
@property (nonatomic, copy, nullable) NSString* v7;
@property (nonatomic, copy, nullable) NSString* v8;
@property (nonatomic, copy, nullable) NSString* v9;
@property (nonatomic, copy, nullable) NSString* v10;
@end

/**
 百度移动应用统计接口
 当前版本 5.3.6_18
 */
@interface BaiduMobStat : NSObject
/**
 以下property属性，均为可选设置。
 如需设置，必须在startWithAppId:方法前调用才可生效。
 */

/**
 设置用户自定义的用户识别id，在startWithAppId之前调用
 设置一次UserId后，用户被永久标记。传入新的userId将替换老的userId。
 传入nil或空字符串@""，可清空标记。
 自定义规则的用户识别id（可以使登录用户账号、手机号等），长度限制256字节
 */
@property (nonatomic, copy, nullable) NSString *userId;

/**
 设置app的版本号
 从4.1版本开始，默认统计CFBundleShortVersionString中的版本号（即与AppStore上一致的版本号）
 如需统计自行设定的版本号，可由此传入
 */
@property (nonatomic, copy) NSString *shortAppVersion;

/**
 设置渠道Id
 默认值为 "AppStore"
 */
@property (nonatomic, copy) NSString *channelId;

/**
 是否启用Crash日志收集
 默认值 YES
 */
@property (nonatomic) BOOL enableExceptionLog;

/**
 是否仅在wifi网络状态下才发送日志
 默认值 NO
 */
@property (nonatomic) BOOL logSendWifiOnly;

/**
 设置应用进入后台再回到前台为同一次启动的最大间隔时间，有效值范围0～600s
 例如设置值30s，则应用进入后台后，30s内唤醒为同一次启动
 默认值 30s
 */
@property (nonatomic) int sessionResumeInterval;

/**
 设置日志发送策略
 默认值 BaiduMobStatLogStrategyAppLaunch
 */
@property (nonatomic) BaiduMobStatLogStrategy logStrategy;

/**
 设置是否打印SDK中的日志，用于调试
 默认值 NO
 */
@property (nonatomic) BOOL enableDebugOn;

/**
 设置设备adid
 若有需要，开发者可自行获取到adid后传入，使统计更精确
 默认值 空字符串:@""
 */
@property (nonatomic, copy) NSString *adid;

/**
 设置是否允许监控webview（V4.6.7新增）
 默认为YES
 */
@property (nonatomic, assign) BOOL enableWebViewAutoTrack;

/**
 当enableWebViewAutoTrack属性设置为NO时，该接口无效，可忽略。
 当多个webview的delegate类存在继承关系时，为了避免因调用super方法而导致的死循环风险，可以设置是否只统计子类Delegate（V4.9.5新增）
 备注：在webview的delegate方法中没有调用super方法的情况下，不受影响。此时为了保证数据完整，不建议设置为YES。
 默认为NO
 */
@property (nonatomic, assign) BOOL onlyTrackSubClassOfWebDelegate;

/**
 设置UIViewController是否监控（V4.6.7新增）
 默认为YES
 */
@property (nonatomic, assign) BOOL enableViewControllerAutoTrack;

/**
 设置是否优先使用“类名”进行UIViewController的页面统计（V5.0.0新增）
 默认为NO，即优先使用页面title进行统计，没有title情况下再使用类名统计
 （推荐）设置为YES，即使用类名进行页面统计，统计效果更准确、聚合度更高
 */
@property (nonatomic, assign) BOOL trackViewControllerWithClassName;

/**
 设置控件点击event事件是否监控（V4.8.3新增）
 默认为YES
 */
@property (nonatomic, assign) BOOL enableEventAutoTrack;

/**
 设置是否允许推送文案的采集，用于启动来源分析（V4.9.5新增）
 默认为YES
 */
@property (nonatomic, assign) BOOL enableGetPushContent;

/**
 设置TableView监控策略（V4.8.0新增）
 默认为BaiduMobStatFeedTrackStrategyAll，全部监控
 设置为BaiduMobStatFeedTrackStrategySingle单个监控，则要监控的tableview需要设置enableListTrack属性为YES
 设置为BaiduMobStatFeedTrackStrategyNone，则不监控任何列表
 */
@property (nonatomic, assign) BaiduMobStatFeedTrackStrategy feedTrackStrategy;

/**
 设置是否使用启动来源分析功能（V4.9.5新增）
 默认为YES
 */
@property (nonatomic, assign) BOOL enableLaunchRefererTrack;

/**
 设置Crash日志中附带的信息
 长度限制256字节，超出截断
 */
@property (nonatomic, copy, nullable) NSString *crashExtraInfo;

/**
 设置app是否为仅浏览模式，该模式下所有行为打点采集无效，包括手动埋点与全埋点数据
 默认为NO，请谨慎设置。如需要设置建议在startwithappid之前调用
 */
@property (nonatomic, assign) BOOL browseMode;

/**
 设置用户是否给予app隐私授权，如果没有给予隐私授权，则不会采集部分设备信息
 默认为YES，请谨慎设置。如需要设置建议在startwithappid之前调用
 */
@property (nonatomic, assign) BOOL authorizedState;

/**
 设置是否显允许 sdk使用baidu 新一套设备 I D 库功能
 默认YES，允许，sdk将会并通过baidu 新一套设设备 I D 库发起请求获取设备 I D
 若设置为NO，不允许，sdk将不会使用 新一套设设备 I D库任何功能，开发者可通过属性接口 cachedInfo 自行传入信息到 sdk中
 
 @param enableSdkUseNewId 是否显允许 sdk使用baidu 新一套设备 I D 库功能，默认YES
 */
@property (nonatomic, assign) BOOL enableSdkUseNewId;

/**
  主动设置baidu 新一套设备 I D 信息到 sdk中， sdk不缓存通过该接口设置的信息，需要每次启动都设置，设置点见下方介绍
  当enableSdkUseNewId设置为YES时：不需要调用此接口
  当enableSdkUseNewId设置为NO时：需要调用此接口传入新一套设备 I D 信息。需要在两处调用：1. startWithAppId函数之前调用设置 2. baidu 新一套设备 I D 库获取到最新 I D 时调用一次
  
  @param cachedInfo 通过baidu 新一套设备 I D 库 [UserFeedBackLog historyLogs] 接口获取到的原始信息数组
 */
@property (nonatomic, strong) NSArray *cachedInfo;

/**
 设置app类型，从以下类型中选择
 0：标准app
 1：ReactNative
 2：flutter
 3: cordova
 4: apicloud
 默认为0，sdk内部使用，开发者可不设置
 */
@property (nonatomic, assign) NSInteger platformType;

/**
 获取统计对象的实例
 
 @return 一个统计对象实例
 */
+ (BaiduMobStat *)defaultStat;

/**
 设置用户自定义的session属性信息，设置后的下一个session将带上该属性。如果要当前session生效，需要在startWithAppId之前调用
 生效范围: 设置后到下一次冷启动之前生效，即热启动也会使用该属性
 传入nil，可清空标记。
 key值为用户提前在分析云网站创建的“属性名称”，若没有提前创建，则无统计效果。
 setSessionProperty、setPageProperty、setAutoEventProperty、setUserProperty共用属性个数，最多传入100个key-value值，超出部分无效
 每个value长度限制256字节,String格式传入，如果为是非类型则传入'1' '0'、如果是时间信息需要转为时间戳的string格式
 调用例子见demo工程
 */
- (void)setSessionProperty:(nullable NSDictionary *)sessionProperty;

/**
 分析云使用，添加页面属性。
 生效范围: 设置后下一次页面统计会带该属性
 传入nil，可清空标记。
 key值为用户提前在网站创建的“属性名称”，若没有提前创建，则无统计效果。
 setSessionProperty、setPageProperty、setAutoEventProperty、setUserProperty共用属性个数，最多传入100个key-value值，超出部分无效
 每个value长度限制256字节,String格式传入，如果为是非类型，则传入'1' '0'、如果是时间信息需要转为时间戳的string格式
 如果没有设置pageProperty，页面属性默认使用session属性
 调用例子见demo工程
 */
- (void)setPageProperty:(nullable NSDictionary *)pageProperty;

/**
 分析云使用，添加全埋点事件属性。
 生效范围: 设置后下一次全埋点事件会带该属性
 传入nil，可清空标记。
 key值为用户提前在网站创建的“属性名称”，若没有提前创建，则无统计效果。
 setSessionProperty、setPageProperty、setAutoEventProperty、setUserProperty共用属性个数，最多传入100个key-value值，超出部分无效
 每个value长度限制256字节,String格式传入，如果为是非类型，则传入'1' '0'、如果是时间信息需要转为时间戳的string格式
 如果没有设置autoEventProperty，页面属性默认使用session属性
 调用例子见demo工程
 */
- (void)setAutoEventProperty:(nullable NSDictionary *)autoEventProperty;

/**
 设置用户自定义的用户属性信息，在startWithAppId之前调用
 设置一次UserPorperty后，属性与该设备绑定。传入新的UserPorperty将替换老的UserPorperty内容。
 传入nil，可清空标记。
 key值为用户提前在网站创建的“属性名称”，若没有提前创建，则无统计效果。
 setSessionProperty、setPageProperty、setAutoEventProperty、setUserProperty共用属性个数，最多传入100个key-value值，超出部分无效
 每个value长度限制256字节,String格式传入，如果为是非类型，则传入'1' '0'、如果是时间信息需要转为时间戳的string格式
 调用例子见demo工程
 */
- (void)setUserProperty:(nullable NSDictionary *)userProperty;

/**
 设置应用的appkey，启动统计SDK。
 注意！！！以下行为Api调用前，必须先调用该接口。
 
 @param appKey 用户在mtj网站上创建应用，获取对应的appKey
 */
- (void)startWithAppId:(NSString *)appKey;

/**
 设置全局附加信息
 此API调用后的日志信息才会有全局附加信息
 若多次调用，后续调用会覆盖之前的信息，以最后一次调用为准
 
 @param info 全局附加信息
 */
- (void)setGlobalExtraInfo:(BaiduMobStatExtraInfo *) info;

/**
 清空全局附加信息
 */
- (void)clearGlobalExtraInfo;

/**
 记录一次事件的点击，eventId请在网站上创建。未创建的evenId记录将无效。
 
 @param eventId 自定义事件Id，提前在网站端创建
 */
- (void)logEvent:(NSString *)eventId;

/**
 记录一次事件的时长，eventId请在网站上创建。未创建的evenId记录将无效。
 
 @param eventId 自定义事件Id，提前在网站端创建
 @param duration 已知的自定义事件时长，单位为毫秒（ms）
 */
- (void)logEventWithDurationTime:(NSString *)eventId durationTime:(unsigned long)duration;

/**
 记录一次事件的开始，eventId请在网站上创建。未创建的evenId记录将无效。
 
 @param eventId 自定义事件Id，提前在网站端创建
 */
- (void)eventStart:(NSString *)eventId;

/**
 记录一次事件的结束，eventId请在网站上创建。未创建的evenId记录将无效。
 
 @param eventId 自定义事件Id，提前在网站端创建
 */
- (void)eventEnd:(NSString *)eventId;

/**
 记录一次事件的点击，eventId和对应的attribute的key请在网站上创建，未创建的evenId和key将无法统计。
 
 @param eventId 事件Id，提前在网站端创建
 @param attributes 事件属性，对应的key需要在网站上创建，注意：value只接受NSString
 */
- (void)logEvent:(NSString *)eventId attributes:(nullable NSDictionary *)attributes;

/**
 记录一次事件的时长，eventId和对应的attribute的key请在网站上创建，未创建的evenId和key将无法统计。
 
 @param eventId 自定义事件Id，提前在网站端创建
 @param duration 已知的自定义事件时长，单位为毫秒（ms）
 @param attributes 事件属性，对应的key需要在网站上创建，注意：value只接受NSString
 */
- (void)logEventWithDurationTime:(NSString *)eventId durationTime:(unsigned long)duration attributes:(nullable NSDictionary *)attributes;

/**
 记录一次事件的结束，eventId和对应的attribute的key请在网站上创建，未创建的evenId和key将无法统计。
 
 @param eventId 自定义事件Id，提前在网站端创建
 @param attributes 事件属性，对应的key需要在网站上创建，注意：value只接受NSString
 */
- (void)eventEnd:(NSString *)eventId attributes:(nullable NSDictionary *) attributes;

/**
 记录某个页面访问的开始，请参见Example程序，在合适的位置调用。
 建议在ViewController的viewDidAppear函数中调用
 
 @param name 页面名称
 */
- (void)pageviewStartWithName:(NSString *)name;

/**
 记录某个页面访问的结束，与pageviewStartWithName配对使用，请参见Example程序，在合适的位置调用。
 建议在ViewController的viewDidDisappear函数中调用
 
 @param name 页面名称
 */
- (void)pageviewEndWithName:(NSString *)name;

/**
 记录WkWebView中的行为（需要在网页的JS代码中进行相应配置，详见文档与Demo程序）
 在WkWebview的代理方法:
 -(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
 中，调用此接口，传入参数为message.name和message.body，开始统计JS中的操作
 
 @param name WKScriptMessage的name
 @param body WKScriptMessage的body 只接受NSDictionary类型
 */
- (void)didReceiveScriptMessage:(NSString*)name body:(NSDictionary *)body;

/**
 主动上传的Exception信息记录
 
 @param exception 自己捕获的，需要上传的exception
 */
- (void)recordException:(NSException *)exception;

/**
 主动上传的NSError信息记录
 
 @param error 自己捕获的，需要上传的error
 */
- (void)recordError:(NSError *)error;

/**
 获取cuid的值
 返回SDK生成的cuid
 
 @return 设备Cuid
 */
- (NSString *)getDeviceCuid;

/**
 获取设备的测试ID，同时有Log打印
 返回SDK生成的设备测试ID
 
 @return 设备测试ID
 */
- (NSString *)getTestDeviceId;

/**
 上传第三方Push平台的Id，pushId长度限制1024字节。设置为nil或者空字符串，则清空对应平台的pushId
 
 @param pushId 从第三方Push SDK接口中获取的pushId
 @param platform 指定Push平台类型，详见枚举声明
 */
- (void)setPushId:(nullable NSString *)pushId platform:(BaiduMobStatPushPlatform)platform;

/**
 传入scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts 中的URLContexts参数
 与scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions中connectionOptions.URLContexts参数
 用于统计启动来源、二维码圈选等功能

@param URLContexts scene:openURLContexts:回调函数的参数
*/
#ifdef __IPHONE_13_0
- (void)mtjOpenURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts;
#endif

@end

/**
 以下方法未来可能会被弃用，请使用上边相应的无eventLabel参数的方法。

 eventId        自定义事件Id，提前在网站端创建
 eventLabel  自定义事件Label，不能为nil
 duration       已知的自定义事件时长，单位为毫秒（ms）
 attributes     事件属性，对应的key需要在网站上创建，注意：value只接受NSString
 
 @discussion eventLabel本质也是一个事件属性，所以可以弃用这个概念，仅使用attributes参数
 */
@interface BaiduMobStat (Deprecated)

- (void)logEvent:(NSString *)eventId eventLabel:(NSString *)eventLabel;
- (void)logEventWithDurationTime:(NSString *)eventId eventLabel:(NSString *)eventLabel durationTime:(unsigned long)duration;
- (void)eventStart:(NSString *)eventId eventLabel:(NSString *)eventLabel;
- (void)eventEnd:(NSString *)eventId eventLabel:(NSString *)eventLabel;

- (void)logEvent:(NSString *)eventId eventLabel:(NSString *)eventLabel attributes:(nullable NSDictionary *)attributes;
- (void)logEventWithDurationTime:(NSString *)eventId eventLabel:(NSString *)eventLabel durationTime:(unsigned long)duration attributes:(nullable NSDictionary *)attributes;
- (void)eventEnd:(NSString *)eventId eventLabel:(NSString *)eventLabel attributes:(nullable NSDictionary *)attributes;

@end

/**
 Category 声明
 */
@interface UIViewController (BaiduMobStatViewController)
/**
 是否禁用自动收集此页面，默认为NO
 */
@property (nonatomic, assign) BOOL disableBaiduMobAutoRecord;

/**
 手动设置自动收集的页面名称
 */
@property (nonatomic, copy, nullable) NSString *titleForBaiduMobStat;

@end

/**
 百度移动统计UIView Category
 */
@interface UIView (BaiduMobStatView)

/**
 手动设置自动收集的附加信息
 对应的key需要在网站上创建，注意：value只接受NSString
 */
@property (nonatomic, copy, nullable) NSDictionary *attributesForBaiduMobStat;

@end

/**
 百度移动统计UITableView Category
 */
@interface UITableView (BaiduMobStatTableView)

/**
 设置TableView的栏目名称，为MTJ分析信息流报表中的”栏目名称“,长度限制256字节，超出截断
 如果不设置，则默认采用tableview所在的Controller title作为“栏目名称”
 建议在TableView加载前设置。
 */
@property (nonatomic, copy, nullable) NSString *listName;

/**
 设置单个TableView是否需要被监控
 默认情况下，sdk监控全局TableView，不需要设置该接口
 当设置了全局关闭之后，可以设置单个tableview打开指定的TableView监控
 */
@property (nonatomic, assign) BOOL enableListTrack;

@end

@interface UITableViewCell (BaiduMobStatTableViewCell)

/**
 设置Cell的信息Title，为MTJ分析信息流报表中的”信息标题“,长度限制256字节，超出截断
 如果不设置，则SDK会自动识别一个Title
 建议在cell加载前设置。
 */
@property (nonatomic, copy, nullable) NSString *contentTitle;

/**
 设置Cell的信息ID，是用户自身系统中的内容id,长度限制256字节，超出截断
 如果不设置，则id为空
 建议在cell加载前设置。
 */
@property (nonatomic, copy, nullable) NSString *contentId;

@end

NS_ASSUME_NONNULL_END
