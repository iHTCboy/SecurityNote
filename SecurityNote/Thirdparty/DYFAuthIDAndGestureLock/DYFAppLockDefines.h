//
//  DYFAppLockDefines.h
//
//  Created by dyf on 2017/7/24.
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

#import "DYFAppLockConstant.h"

#ifndef DYFAppLockDefines_h
#define DYFAppLockDefines_h

// 屏幕大小
#define DYFScreenBounds [UIScreen mainScreen].bounds

// 屏幕宽
#define DYFScreenWidth  DYFScreenBounds.size.width
// 屏幕高
#define DYFScreenHeight DYFScreenBounds.size.height

// 手势密码提示Label的高度
#define DYFLabelHeight  20.f
// 手势密码九宫格view的宽高
#define DYFGestureWH    280.f

// View safe insets.
#define DYFViewSafeAreaInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

// 资源bundle名称
#define DYFAuthIDAndGestureLockBundle @"DYFAuthIDAndGestureLock.bundle"

// 资源bundle路径
#define DYFAuthIDAndGestureLockBundlePath [[NSBundle mainBundle] pathForResource:DYFAuthIDAndGestureLockBundle ofType:nil]

// 通过名字获取图像
#define DYFImageNamed(name) [UIImage imageNamed:[DYFAuthIDAndGestureLockBundlePath stringByAppendingPathComponent:(name)]]

// User Defaults
#define DYFUserDefaults  [NSUserDefaults standardUserDefaults]

// 获取iOS版本
#define DYFSystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]

// 根据16位Hex值转换成颜色，格式:DYFColorFromHex(0xFF0000, 1.f)
#define DYFColorFromHex(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alp]

// 根据RBG值转换成颜色, 格式:DYFColorFromRGB(255, 255, 255, 1.f)
#define DYFColorFromRGB(r, g, b, alp) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alp]

// Resolving block circular reference - __weak(arc)
#ifndef DYFWeakObject
    #if __has_feature(objc_arc)
        #define DYFWeakObject(o) try {} @finally {} __weak __typeof(o) weak##_##o = o;
    #else
        #define DYFWeakObject(o) try {} @finally {} __block __typeof(o) weak##_##o = o;
    #endif
#endif

// Resolving block circular reference - strong(arc)
#ifndef DYFStrongObject
    #if __has_feature(objc_arc)
        #define DYFStrongObject(o) try {} @finally {} __strong __typeof(o) strong##_##o = weak##_##o;
    #else
        #define DYFStrongObject(o) try {} @finally {} __typeof(o) strong##_##o = weak##_##o;
    #endif
#endif

// Output Logs
#ifdef DEBUG
    #define DYFDLog(fmt, ...) NSLog((@"[file: %s] [func: %s] [line: %d] " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DYFDLog(...) {}
#endif

#endif /* DYFAppLockDefines_h */
