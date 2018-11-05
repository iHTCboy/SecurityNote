//
//  DHDeviceUtil.h
//  Dash iOS
//
//  Created by HTC on 2017/5/3.
//  Copyright © 2017年 Kapeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define  MACRO_IS_GREATER_OR_EQUAL_TO_IOS(v) ([[[UIDevice currentDevice] systemVersion] floatValue] >= v)

#define  MACRO_IS_IPHONE_X   (MACRO_IS_GREATER_OR_EQUAL_TO_IOS(11.0) ? (!UIEdgeInsetsEqualToEdgeInsets([[[UIApplication sharedApplication].keyWindow valueForKey:@"safeAreaInsets"] UIEdgeInsetsValue], UIEdgeInsetsZero)) : NO)

@interface DHDeviceUtil : NSObject

+(NSString *)deviceModelName;

@end
