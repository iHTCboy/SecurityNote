//
//  DYFCircleView.m
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

#import "DYFCircleView.h"

// 外空心圆边界宽度
CGFloat const circleBorderWidth = 1.f;
// 内部的实心圆所占外圆的比例大小
CGFloat const circleRatio       = 0.3f;
// 三角形箭头的边长
CGFloat const arrowH            = 8.f;

@interface DYFCircleView ()
/**
 * 手势圆圈的颜色
 */
@property (nonatomic, strong) UIColor *circleColor;
@end

@implementation DYFCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.circleStatus    = CircleViewStatusNormal;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
    CGContextRef cr = UIGraphicsGetCurrentContext();
    CGContextClearRect(cr, rect);
    
    // 画外圆
    CGFloat circleDiameter = MIN(rect.size.width, rect.size.height) - circleBorderWidth * 2.0;
    CGRect circleInRect = CGRectMake(circleBorderWidth, circleBorderWidth, circleDiameter, circleDiameter);
    CGContextAddEllipseInRect(cr, circleInRect);
    CGContextSetLineWidth(cr, circleBorderWidth);
    [self.circleColor set];
    CGContextStrokePath(cr);
    
    // 画内实心圆
    if (self.circleStatus != CircleViewStatusNormal) {
        CGFloat filledCircleDiameter = circleDiameter * circleRatio;
        CGFloat filledCircleX = (rect.size.width - filledCircleDiameter)*0.5;
        CGFloat filledCircleY = (rect.size.height - filledCircleDiameter)*0.5;
        CGContextAddEllipseInRect(cr, CGRectMake(filledCircleX, filledCircleY, filledCircleDiameter, filledCircleDiameter));
        [self.circleColor set];
        CGContextFillPath(cr);
        
        // 画指示方向三角箭头
        if (self.circleStatus == CircleViewStatusSelectedAndShowArrow
            || self.circleStatus == CircleViewStatusErrorAndShowArrow) {
            // 先平移到圆心然后在旋转，然后在平移回来
            CGFloat offset = MIN(rect.size.width, rect.size.height) * 0.5;
            CGContextTranslateCTM(cr, offset, offset);
            CGContextRotateCTM(cr, self.angle);
            CGContextTranslateCTM(cr, -offset, -offset);
            
            CGFloat arrowMargin = (filledCircleY - arrowH) * 0.5;
            CGContextMoveToPoint(cr, (rect.size.width - arrowH * 1.5) * 0.5 , filledCircleY - arrowMargin);
            CGContextAddLineToPoint(cr, (rect.size.width + arrowH * 1.5) * 0.5 , filledCircleY - arrowMargin);
            CGContextAddLineToPoint(cr, rect.size.width * 0.5 , filledCircleY - arrowMargin - arrowH);
            CGContextClosePath(cr);
            CGContextSetFillColorWithColor(cr, self.circleColor.CGColor);
            CGContextFillPath(cr);
        }
    }
}

- (void)setCircleStatus:(CircleViewStatus)circleStatus {
    _circleStatus = circleStatus;
    
    if (_circleStatus == CircleViewStatusNormal) {
        self.circleColor = CircleNormalColor;
    } else if (_circleStatus == CircleViewStatusSelected || _circleStatus == CircleViewStatusSelectedAndShowArrow) {
        self.circleColor = CircleSelectedColor;
    } else if (_circleStatus == CircleViewStatusError || _circleStatus == CircleViewStatusErrorAndShowArrow) {
        self.circleColor = CircleErrorColor;
    }
    
    [self setNeedsDisplay];
}

@end
