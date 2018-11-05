//
//  TCYearPickerView.m
//  SecurityNote
//
//  Created by HTC on 14-9-30.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCYearPickerView.h"

@interface TCYearPickerView()

@property (nonatomic, weak) UIPickerView * yearPicker;

@end

@implementation TCYearPickerView

@synthesize yearPickers;

CGRect viewFrame;

//初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        viewFrame = frame;
        
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 256);
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.9;
        
        UIPickerView * yearPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 25,viewFrame.size.width, 216)];
     
        
     
        //内部全局的picker
        self.yearPicker = yearPicker;
        
        //外部全局的picker
        yearPickers = self.yearPicker;
        
        [self toolTateBar];
        
        [self addSubview:yearPicker];
        
    }
    return self;
}



+(TCYearPickerView *)initWithPicker:(CGRect )viewFrame
{
    
    return [[self alloc]initWithFrame:viewFrame];
    
}



//显示时间选择器
-(void) popYearPickerView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = CGRectMake(0, viewFrame.size.height - 256, viewFrame.size.width, 256);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//隐藏时间选择器
-(void) hiddenYearPickerView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = CGRectMake(0, viewFrame.size.height, viewFrame.size.width, 216);
        
    } completion:^(BOOL finished) {
        
    }];
    
}



//取消选择时间
-(void)cancelDate:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCancelSelectYear)])
    {
        [self.delegate didCancelSelectYear];
    }
    
    [self hiddenYearPickerView];
    
}


//保存选择的时间
-(void)saveDate:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSaveYear)])
    {
        [self.delegate didSaveYear];
    }
    
    [self hiddenYearPickerView];
    
}



//选择器上的工具项
-(void)toolTateBar
{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewFrame.size.width, 30)];
    
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 5, 60, 30)];
    leftBtn.selected = NO;
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor: [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    leftBtn.layer.cornerRadius = 5;
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] CGColor];
    
    
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewFrame.size.width - 68 , 5, 60, 30)];
    
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    rightBtn.layer.cornerRadius = 5;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] CGColor];
    
    
    
    [leftBtn addTarget:self action:@selector(cancelDate:) forControlEvents:UIControlEventAllEvents];
    
    [rightBtn addTarget:self action:@selector(saveDate:) forControlEvents:UIControlEventAllEvents];
    
    
    
    [topView addSubview:leftBtn];
    [topView addSubview:rightBtn];
    
    [self addSubview:topView];
    
}

@end
