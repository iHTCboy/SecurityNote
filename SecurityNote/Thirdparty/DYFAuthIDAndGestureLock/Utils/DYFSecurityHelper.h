//
//  DYFSecurityHelper.h
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017 dyf. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

/**
 Touch ID/Face ID认证的回调函数
 
 @param success 认证的结果
 @param shouldEnterPassword 输入登录密码的认证
 @param message 提示信息
 */
typedef void (^DYFAuthIDEvaluationBlock)(BOOL success, BOOL shouldEnterPassword, NSString *message);

@interface DYFSecurityHelper : NSObject

// 单例
+ (instancetype)sharedHelper;

// 手势密码是否开启
+ (BOOL)gestureCodeOpen;

// 关闭/开启手势密码
+ (void)setGestureCodeOpen:(BOOL)open;

// 手势密码轨迹是否显示
+ (BOOL)gestureCodeTrackShown;

// 关闭/开启手势密码轨迹
+ (void)setGestureCodeTrackShown:(BOOL)shown;

// 获取保存手势密码
+ (NSString *)getGestureCode;

// 保存手势密码
+ (void)setGestureCode:(NSString *)gestureCode;

// AuthID是否开启
+ (BOOL)authIDOpen;

// 关闭/开启AuthID
+ (void)setAuthIDOpen:(BOOL)open;

// 能否验证
+ (BOOL)canAuthenticate;

// 设备是否支持Face ID
+ (BOOL)faceIDAvailable;

// 设备是否支持Touch ID
+ (BOOL)touchIDAvailable;

// 验证AuthID
- (void)evaluateAuthID:(DYFAuthIDEvaluationBlock)block;

@end
