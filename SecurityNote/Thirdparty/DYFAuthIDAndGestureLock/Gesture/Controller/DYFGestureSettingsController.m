//
//  DYFGestureSettingsController.m
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

#import "DYFGestureSettingsController.h"
#import "DYFAppLockDefines.h"

#import "CALayer+Shake.h"
#import "UIView+Ext.h"
#import "UIButton+EdgeInsets.h"

#import "DYFCircleView.h"
#import "DYFGestureView.h"
#import "DYFGestureShapeView.h"

#import "DYFSecurityHelper.h"
#import "UIViewController+Message.h"

#define MarginTop                     30.f
#define Margin                        10.f
#define ShapeWH                       40.f
#define BottomHeight                  50.f

@interface DYFGestureSettingsController ()
// 手势缩略图
@property (nonatomic, strong) DYFGestureShapeView *shapeView;
// 手势九宫格
@property (nonatomic, strong) DYFGestureView *gestureView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic,   copy) NSString *firstGestureCode;

@property (nonatomic,   copy) DYFGestureSettingsBlock completionHandler;
@end

@implementation DYFGestureSettingsController

- (instancetype)init {
    self = [super init];
    if (self) {
        _gestureSettingsType = DYFGestureSettingsTypeChange;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configureNavigationBar {
    self.title = NSLocalizedString(kSetGustureCodeText, nil);
    
    if (self.gestureSettingsType == DYFGestureSettingsTypeDelete) {
        self.title = NSLocalizedString(kVerifyGustureCodeText, nil);
    }
}

- (void)setupSubviews {
    // 设置坐标从(0, 0)开始时，不会被导航条遮挡.
    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self.view addSubview:self.shapeView];
    [self.view addSubview:self.messageLabel];
    
    if (self.gestureSettingsType != DYFGestureSettingsTypeSet) {
        if ([self.shapeView superview]) {
            [self.shapeView removeFromSuperview];
        }
        self.messageLabel.top = MarginTop + Margin;
        self.messageLabel.text = NSLocalizedString(kPromptChangeGestureMessage, nil);
    }
    
    [self setupGestureView];
}


// 手势九宫格
- (void)setupGestureView {
    [self.view addSubview:self.gestureView];
    
    // 是否显示指示手势划过的方向箭头, 在初始设置手势密码的时候才显示, 其他的不用显示
    self.gestureView.showArrowDirection = (self.gestureSettingsType == DYFGestureSettingsTypeSet) ? YES : NO;
    
    @DYFWeakObject(self)
    [self.gestureView setGestureResult:^BOOL(NSString *gestureCode) {
        return [weak_self gestureResult:gestureCode];
    }];
}

// 验证手势密码成功后，修改手势密码
- (void)resetTopViews {
    if (self.gestureSettingsType != DYFGestureSettingsTypeChange) {
        return;
    }
    
    self.gestureSettingsType = DYFGestureSettingsTypeSet;
    if (![self.shapeView superview]) {
        [self.view addSubview:self.shapeView];
    }
    
    self.firstGestureCode = nil;
    
    self.messageLabel.top = MarginTop + ShapeWH + Margin;
    self.messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
    if (@available(iOS 13.0, *)) {
        self.messageLabel.textColor = UIColor.labelColor;
    } else {
        self.messageLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - 懒加载

// 缩略图
- (DYFGestureShapeView *)shapeView {
    if (!_shapeView) {
        CGFloat shapeX = (DYFScreenWidth - ShapeWH) * 0.5;
        _shapeView = [[DYFGestureShapeView alloc] initWithFrame:CGRectMake(shapeX, MarginTop, ShapeWH, ShapeWH)];
        _shapeView.backgroundColor = [UIColor clearColor];
    }
    return _shapeView;
}

// 手势九宫格
- (DYFGestureView *)gestureView {
    if (!_gestureView) {
        CGFloat gestureViewX = (DYFScreenWidth - DYFGestureWH) * 0.5;
        CGFloat gestureViewY = MarginTop * 2 + Margin + ShapeWH + DYFLabelHeight;
        _gestureView = [[DYFGestureView alloc] initWithFrame:CGRectMake(gestureViewX, gestureViewY, DYFGestureWH, DYFGestureWH)];
    }
    return _gestureView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat labelY = MarginTop + ShapeWH + Margin;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, labelY, DYFScreenWidth - 2 * Margin, DYFLabelHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:16.f];
        _messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
        if (@available(iOS 13.0, *)) {
            _messageLabel.textColor = UIColor.labelColor;
        }
    }
    return _messageLabel;
}

#pragma mark - 对外方法

// 手势设置完成的回调
- (void)gestureSettingsWithCompletion:(DYFGestureSettingsBlock)completionHandler {
    self.completionHandler = completionHandler;
}

#pragma mark - action事件

// 点击返回设置失败
- (void)backBtnClicked:(UIButton *)sender {
    !self.completionHandler ?: self.completionHandler(NO);
    [self back];
}

#pragma mark - 对内方法

// 重设手势
- (void)resetGesture {
    //[self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.shapeView.gestureCode = nil;
    self.firstGestureCode = nil;
    self.messageLabel.text = NSLocalizedString(kPromptDefaultMessage, nil);
    self.messageLabel.textColor = CircleErrorColor;
}

- (void)back {
    UINavigationController *nc = self.navigationController;
    [nc popViewControllerAnimated:YES];
}

// 手势密码的结果处理
- (BOOL)gestureResult:(NSString *)gestureCode {
    if (self.gestureSettingsType == DYFGestureSettingsTypeSet) {
        
        // 首次设置手势密码
        if (gestureCode.length >= 4) {
            
            if (!self.firstGestureCode) {
                
                self.shapeView.gestureCode = gestureCode;
                self.firstGestureCode = gestureCode;
                self.messageLabel.text = NSLocalizedString(kPromptSetAgainMessage, nil);
                if (@available(iOS 13.0, *)) {
                    self.messageLabel.textColor = UIColor.labelColor;
                }
                return YES;
                
            } else if ([self.firstGestureCode isEqualToString:gestureCode]) {
                
                // 第二次绘制成功，返回上一页
                [DYFSecurityHelper setGestureCode:gestureCode];
                
                !self.completionHandler ?: self.completionHandler(YES);
                [self yf_showMessage:NSLocalizedString(kSettingSuccessfulText, nil)];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self back];
                });
                
                return YES;
            }
        }
        
        // 点数少于4 或者 前后不一致
        if (gestureCode.length < 4 || self.firstGestureCode != nil) {
            
            // 点数少于4 或者 前后不一致
            self.messageLabel.text = NSLocalizedString(gestureCode.length < 4 ? kPromptPointShortMessage : kPromptSetAgainErrorMessage, nil);
            self.messageLabel.textColor = CircleErrorColor;
            [self.messageLabel.layer shake];
            
            [self performSelector:@selector(resetGesture) withObject:nil afterDelay:1.0];
            
            return NO;
        }
        
    } else if (self.gestureSettingsType == DYFGestureSettingsTypeDelete) {
        
        // 密码验证
        if ([self verifyGestureCode:gestureCode]) {
            // 验证成功，关闭手势密码
            [DYFSecurityHelper setGestureCode:nil];
            
            !self.completionHandler ?: self.completionHandler(YES);
            [self back];
            
            return YES;
        }
        
        return NO;
        
    } else if (self.gestureSettingsType == DYFGestureSettingsTypeChange) {
        
        // 修改手势密码，修改前先验证原密码
        if ([self verifyGestureCode:gestureCode]) {
            [self resetTopViews];
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

// 验证原密码
- (BOOL)verifyGestureCode:(NSString *)gestureCode {
    NSString *code = [DYFSecurityHelper getGestureCode];
    
    if ([code isEqualToString:gestureCode]) {
        return YES;
    } else {
        self.messageLabel.text = NSLocalizedString(kPromptPasswordErrorMessage, nil);
        self.messageLabel.textColor = CircleErrorColor;
        [self.messageLabel.layer shake];
        
        return NO;
    }
}

- (void)dealloc {
    DYFDLog(@"%s",  __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
