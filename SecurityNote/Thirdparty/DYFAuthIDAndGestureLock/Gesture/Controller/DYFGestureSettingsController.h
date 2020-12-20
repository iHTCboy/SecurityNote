//
//  DYFGestureSettingsController.h
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

#import "DYFBaseViewController.h"

typedef NS_ENUM(NSInteger, DYFGestureSettingsType) {
    DYFGestureSettingsTypeSet = 1,  // 设置
    DYFGestureSettingsTypeDelete,   // 删除设置
    DYFGestureSettingsTypeChange    // 修改
};

// 设置的回调函数
typedef void (^DYFGestureSettingsBlock)(BOOL successful);

@interface DYFGestureSettingsController : DYFBaseViewController

@property (nonatomic, assign) DYFGestureSettingsType gestureSettingsType;

// 手势设置完成的回调
- (void)gestureSettingsWithCompletion:(DYFGestureSettingsBlock)completionHandler;

@end
