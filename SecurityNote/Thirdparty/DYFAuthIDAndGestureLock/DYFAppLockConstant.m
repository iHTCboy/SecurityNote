//
//  DYFAppLockConstant.m
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

NSString *const kAuthIDOpen                 = @"kAuthIDOpen";
NSString *const kGustureCodeOpen            = @"kGustureCodeOpen";
NSString *const kGustureCodeRecord          = @"kGustureCodeRecord";
NSString *const kGustureCodeTrackShown      = @"kGustureCodeTrackShown";

NSString *const kSetGustureCodeText         = @"设置手势密码";
NSString *const kVerifyGustureCodeText      = @"验证手势密码";
NSString *const kPasswordErrorMessage       = @"手势密码错误";
NSString *const kSettingSuccessfulText      = @"设置成功";

NSString *const kPromptDefaultMessage       = @"绘制解锁图案";
NSString *const kPromptSetAgainMessage      = @"请再次绘制解锁图案";
NSString *const kPromptSetAgainErrorMessage = @"与上一次输入不一致，请重新设置";
NSString *const kPromptChangeGestureMessage = @"请输入原手势密码";
NSString *const kPromptPointShortMessage    = @"密码太短，至少4位，请重新设置";
NSString *const kPromptPasswordErrorMessage = @"手势密码错误";
