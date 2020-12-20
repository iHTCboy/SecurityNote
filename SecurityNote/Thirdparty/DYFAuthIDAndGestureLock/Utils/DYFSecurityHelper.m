//
//  DYFSecurityHelper.m
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

#import "DYFSecurityHelper.h"
#import "DYFAppLockDefines.h"
#import "UIView+Ext.h"

@import LocalAuthentication;

@interface DYFSecurityHelper ()
@property (nonatomic, copy) DYFAuthIDEvaluationBlock block;
@end

@implementation DYFSecurityHelper

// 单例
+ (instancetype)sharedHelper {
    static DYFSecurityHelper *_inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inst = [[[self class] alloc] init];
    });
    return _inst;
}

#pragma mark - 手势密码

// 手势密码是否开启
+ (BOOL)gestureCodeOpen {
    NSNumber *n = [DYFUserDefaults objectForKey:kGustureCodeOpen];
    BOOL b = n ? [n boolValue] : NO;
    return b;
}

// 关闭/开启手势密码
+ (void)setGestureCodeOpen:(BOOL)open {
    NSNumber *n = open ? @(1) : @(0);
    
    [DYFUserDefaults setObject:n forKey:kGustureCodeOpen];
    [DYFUserDefaults synchronize];
    
    if (!open) {
        [self setGestureCode:nil];
    }
}

// 手势密码轨迹是否显示
+ (BOOL)gestureCodeTrackShown {
    NSNumber *n = [DYFUserDefaults objectForKey:kGustureCodeTrackShown];
    BOOL b = n ? [n boolValue] : NO;
    return b;
}

// 关闭/开启手势密码轨迹
+ (void)setGestureCodeTrackShown:(BOOL)shown {
    NSNumber *n = shown ? @(1) : @(0);
    [DYFUserDefaults setObject:n forKey:kGustureCodeTrackShown];
    [DYFUserDefaults synchronize];
}

// 获取保存手势密码
+ (NSString *)getGestureCode {
    NSString *gestureCode = [DYFUserDefaults objectForKey:kGustureCodeRecord];
    return gestureCode ? gestureCode : @"";
}

// 保存手势密码
+ (void)setGestureCode:(NSString *)gestureCode {
    [DYFUserDefaults setObject:gestureCode forKey:kGustureCodeRecord];
    [DYFUserDefaults synchronize];
}

#pragma mark - AuthID

// AuthID是否开启
+ (BOOL)authIDOpen {
    NSNumber *n = [DYFUserDefaults objectForKey:kAuthIDOpen];
    BOOL b = n ? [n boolValue] : NO;
    return b;
}

// 关闭/开启AuthID
+ (void)setAuthIDOpen:(BOOL)open {
    NSNumber *n = open ? @(1) : @(0);
    [DYFUserDefaults setObject:n forKey:kAuthIDOpen];
    [DYFUserDefaults synchronize];
}

+ (BOOL)canAuthenticate {
    BOOL isBiometricAuthenticationAvailable = NO;
    
    if (@available(iOS 8.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    
    return isBiometricAuthenticationAvailable;
}

+ (BOOL)faceIDAvailable {
    if (@available(iOS 11.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        return ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] && context.biometryType == LABiometryTypeFaceID);
    }
    return NO;
}

+ (BOOL)touchIDAvailable {
    if (@available(iOS 11.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        return ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] && context.biometryType == LABiometryTypeTouchID);
    }
    return NO;
}

- (LAPolicy)devicePolicy {
    if (@available(iOS 9.0, *)) {
        return LAPolicyDeviceOwnerAuthentication;
    } else {
        return LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }
}

// 验证AuthID
- (void)evaluateAuthID:(DYFAuthIDEvaluationBlock)block {
    if (DYFSecurityHelper.canAuthenticate) {
        [self evaluateWithPolicy:self.devicePolicy completion:(self.block = block)];
    }
}

- (void)evaluateWithPolicy:(LAPolicy)policy completion:(DYFAuthIDEvaluationBlock)completion {
    LAContext *context             = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"密码解锁";
    context.localizedCancelTitle   = @"取消";
    NSString *localizedReason      = DYFSecurityHelper.faceIDAvailable ? @"验证FaceID，进入应用" : @"验证Touch ID，进入应用";
    [context evaluatePolicy:policy localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = @"";
            
            if (success) {
                message = DYFSecurityHelper.faceIDAvailable ? @"通过Face ID验证" : @"通过Touch ID验证";
                !completion ?: completion(YES, NO, message);
            } else {
                BOOL shouldEnterPassword = NO;
                
                // Error
                LAError errorCode = error.code;
                
                switch (errorCode) {
                    case LAErrorAuthenticationFailed: {
                        message = @"信息不匹配";
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        message = @"您已取消";
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        shouldEnterPassword = YES;
                        message = @"您选择输入密码";
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        // 对话框被系统取消，如按下Home键或电源键
                        message = @"取消授权，如其他应用切入";
                    }
                        break;
                        
                    case LAErrorAppCancel: {
                        // 如突然来了电话，电话应用进入前台，APP被挂起
                        message = @"APP被挂起，如来了电话";
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        message = @"未设置设备系统密码";
                    }
                        break;
                        
                    default:
                    case LAErrorInvalidContext: {
                        message = @"无效的验证";
                    }
                        break;
                        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
                    case LAErrorBiometryNotAvailable: {
                        message = DYFSecurityHelper.faceIDAvailable ? @"Face ID不可用" : @"Touch ID不可用";
                    }
                        break;
                        
                    case LAErrorBiometryNotEnrolled: {
                        message = DYFSecurityHelper.faceIDAvailable ? @"Face ID未录入" : @"指纹未录入";
                    }
                        break;
                        
                    case LAErrorBiometryLockout: {
                        message = DYFSecurityHelper.faceIDAvailable ? @"Face ID被锁，需要输入密码解锁" : @"Touch ID被锁，需要输入密码解锁";
                    }
                        break;
#else
                    case LAErrorTouchIDNotAvailable: {
                        message = @"Touch ID不可用";
                    }
                        break;
                        
                    case LAErrorTouchIDNotEnrolled: {
                        message = @"指纹未录入";
                    }
                        break;
                        
                    case LAErrorTouchIDLockout: {
                        // 连续2次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        message = @"Touch ID被锁，需要输入密码解锁";
                    }
                        break;
#endif
                }
                
#if DEBUG
                NSLog(@"[LAError] code: %zi, message: %@", errorCode, message);
#endif
                
                !completion ?: completion(success, shouldEnterPassword, message);
            }
        });
        
    }];
}

@end
