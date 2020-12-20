//
//  DYFGestureView.m
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

#import "DYFGestureView.h"
#import "DYFCircleView.h"

// 圆圈九宫格边界大小
CGFloat const CircleViewMarginBorder = 5.f;
CGFloat const CircleViewMarginNear   = 30.f;
// 连线的宽度
CGFloat const LineWidth              = 4.f;
// 圆圈视图tag初始值
NSInteger const CircleViewBaseTag    = 100;

@interface DYFGestureView ()
@property (nonatomic, strong) NSMutableArray *selectCircleArray;
@property (nonatomic, assign) CGPoint currentTouchPoint;
@property (nonatomic, assign) CircleViewStatus CircleViewStatus;
@property (nonatomic, strong) UIColor *lineColor;
@end

@implementation DYFGestureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

// 子视图初始化
- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < 9; i++) {
        DYFCircleView *circleView = [[DYFCircleView alloc] init];
        circleView.tag = i + CircleViewBaseTag;
        [self addSubview:circleView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 手势解锁视图的大小
    CGFloat squareWH = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat offsetY = 0.0;
    CGFloat offsetX = 0.0;
    if (self.frame.size.width >= self.frame.size.height) {
        offsetX = (self.frame.size.width - self.frame.size.height) * 0.5;
    } else {
        offsetY = (self.frame.size.height - self.frame.size.width) * 0.5;
    }
    
    // 小圆的大小
    CGFloat circleWH = (squareWH - (CircleViewMarginBorder+CircleViewMarginNear)*2.0)/3.0;
    
    for (NSInteger i = 0; i < 9; i++) {
        DYFCircleView *circleView = [self viewWithTag:i+CircleViewBaseTag];
        
        NSInteger currentRow = i / 3;
        NSInteger currentColumn = i % 3;
        CGFloat circleX = CircleViewMarginBorder + (CircleViewMarginNear + circleWH) * currentColumn;
        CGFloat circleY = CircleViewMarginBorder + (CircleViewMarginNear + circleWH) * currentRow;
        
        circleView.frame = CGRectMake(circleX + offsetX, circleY + offsetY, circleWH, circleWH);
    }
}

#pragma mark - setter / getter

- (NSMutableArray *)selectCircleArray {
    if (!_selectCircleArray) {
        _selectCircleArray = [NSMutableArray array];
    }
    return _selectCircleArray;
}

- (void)setCircleViewStatus:(CircleViewStatus)CircleViewStatus {
    _CircleViewStatus = CircleViewStatus;
    
    if (_CircleViewStatus == CircleViewStatusNormal) {
        self.lineColor = CircleNormalColor;
    } else if (_CircleViewStatus == CircleViewStatusSelected) {
        self.lineColor = CircleSelectedColor;
    } else if (_CircleViewStatus == CircleViewStatusError) {
        self.lineColor = CircleErrorColor;
    }
}

#pragma mark - draw view

- (void)drawRect:(CGRect)rect {
    if (self.isHideGesturePath) {
        return;
    }
    
    self.clearsContextBeforeDrawing = YES;
    CGContextRef cr = UIGraphicsGetCurrentContext();
    
    // 剪切，画线只能在圆外画
    CGContextAddRect(cr, rect);
    for (NSInteger i = 0; i < 9; i++) {
        DYFCircleView *circleView = [self viewWithTag:(i + CircleViewBaseTag)];
        CGContextAddEllipseInRect(cr, circleView.frame);
    }
    CGContextEOClip(cr);
    
    // 画线
    for (NSInteger i = 0; i < self.selectCircleArray.count; i++) {
        DYFCircleView *circleView = self.selectCircleArray[i];
        CGPoint circleCentre = circleView.center;
        if (i == 0) {
            CGContextMoveToPoint(cr, circleCentre.x, circleCentre.y);
        } else {
            CGContextAddLineToPoint(cr, circleCentre.x, circleCentre.y);
        }
    }
    
    [self.selectCircleArray enumerateObjectsUsingBlock:^(DYFCircleView *circleView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (circleView.circleStatus != CircleViewStatusError
            && circleView.circleStatus != CircleViewStatusErrorAndShowArrow) {
            CGContextAddLineToPoint(cr, self.currentTouchPoint.x, self.currentTouchPoint.y);
        }
    }];
    
    CGContextSetLineCap(cr, kCGLineCapRound);
    CGContextSetLineWidth(cr, LineWidth);
    [self.lineColor set];
    CGContextStrokePath(cr);
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cleanViews];
    [self checkCircleViewTouch:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self checkCircleViewTouch:touches];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString * gestureCode = [NSMutableString string];
    
    for (DYFCircleView *circleView in self.selectCircleArray) {
        [gestureCode appendFormat:@"%zi", (circleView.tag - CircleViewBaseTag)];
        //circleView.circleStatus = CircleViewStatusNormal;
    }
    
    if (gestureCode.length > 0 && self.gestureResult != nil) {
        BOOL successGesture = self.gestureResult(gestureCode);
        
        if (successGesture) {
            [self cleanViews];
        } else {
            if (!self.isHideGesturePath) {
                for (NSInteger i = 0; i < self.selectCircleArray.count; i++) {
                    DYFCircleView *circleView = self.selectCircleArray[i];
                    BOOL showArrow = (self.isShowArrowDirection && i != self.selectCircleArray.count - 1);
                    // 判断是否显示指示方向的箭头, 最后一个不用显示
                    circleView.circleStatus = showArrow ? CircleViewStatusErrorAndShowArrow : CircleViewStatusError;
                    self.CircleViewStatus = CircleViewStatusError;
                    [self setNeedsDisplay];
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cleanViews];
            });
        }
    }
}

- (void)cleanViews {
    for (DYFCircleView *circleView in self.selectCircleArray)  {
        circleView.circleStatus = CircleViewStatusNormal;
    }
    
    [self.selectCircleArray removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)checkCircleViewTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentTouchPoint = point;
    
    for (NSInteger i = 0; i < 9; i++) {
        DYFCircleView *circleView = [self viewWithTag:i+CircleViewBaseTag];
        
        if(CGRectContainsPoint(circleView.frame, point) && ![self.selectCircleArray containsObject:circleView]) {
            if (!self.isHideGesturePath) {
                circleView.circleStatus = CircleViewStatusSelected;
                self.CircleViewStatus = CircleViewStatusSelected;
                
                // 计算最后两个选中圆圈的角度，为了画出指示箭头
                if (self.selectCircleArray.count > 0 && self.isShowArrowDirection) {
                    DYFCircleView *lastSelectCircleView = [self.selectCircleArray lastObject];
                    
                    CGFloat x1 = circleView.center.x;
                    CGFloat y1 = circleView.center.y;
                    CGFloat x2 = lastSelectCircleView.center.x;
                    CGFloat y2 = lastSelectCircleView.center.y;
                    
                    CGFloat angle = atan2(y1 - y2, x1 - x2) + M_PI_2;
                    lastSelectCircleView.angle = angle;
                    lastSelectCircleView.circleStatus = CircleViewStatusSelectedAndShowArrow;
                }
            }
            
            [self.selectCircleArray addObject:circleView];
            
            break;
        }
    }
}

@end
