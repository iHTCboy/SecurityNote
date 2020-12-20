//
//  DYFCircleView.h
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

// 根据Hex值转换成颜色，格式: CCColorFromHex(0xFF0000, 1.0)
#define CCColorFromHex(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alp]

// 手势圆圈正常的颜色
#define CircleNormalColor       CCColorFromHex(0x33CCFF, 1.f)
// 手势圆圈选中的颜色
#define CircleSelectedColor     CCColorFromHex(0x3393F2, 1.f)
// 手势圆圈错误的颜色
#define CircleErrorColor        CCColorFromHex(0xFF0033, 1.f)

typedef NS_ENUM(NSInteger, CircleViewStatus) {
    CircleViewStatusNormal,
    CircleViewStatusSelected,
    CircleViewStatusSelectedAndShowArrow,
    CircleViewStatusError,
    CircleViewStatusErrorAndShowArrow,
};

@interface DYFCircleView : UIView

@property (nonatomic, assign) CircleViewStatus circleStatus;

/**
 * 相邻两圆圈连线的方向角度
 */
@property (nonatomic) CGFloat angle;

@end
