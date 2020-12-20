//
//  DYFAuthenticationView.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DYFAuthenticationType) {
    DYFAuthenticationTypeAuthID, // 指纹ID/面容ID验证
    DYFAuthenticationTypeGesture // 手势密码验证
};

typedef void(^DYFAuthenticationBlock)(BOOL success);
typedef void(^DYFLoginOtherAccountBlock)();

@interface DYFAuthenticationView : UIView
// 头像
@property (nonatomic, strong) UIImage *avatarImage;

// 实例化
- (instancetype)initWithFrame:(CGRect)frame authenticationType:(DYFAuthenticationType)authenticationType;

// 显示View
- (void)show;

// 验证
- (void)authenticateWithCompletion:(DYFAuthenticationBlock)completionHandler;

// 登录其他账户
- (void)loginOtherAccountWithCompletion:(DYFLoginOtherAccountBlock)completionHandler;

@end
