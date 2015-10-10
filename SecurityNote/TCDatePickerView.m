//
//  TCDatePickerView.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-16.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCDatePickerView.h"


@implementation TCDatePickerView

@synthesize datePickers;

UIDatePicker * datePicker;

NSString * turnNowDate;

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
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 25,viewFrame.size.width, 216)];
        
        datePicker.backgroundColor = [UIColor clearColor];
        
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
         //@"en_US"
        
        
        //设置最小时间
        //datePicker.minimumDate = [NSDate date];
        
        datePickers = datePicker;

        [self.datePickers addTarget:self action:@selector(didDateChange) forControlEvents:UIControlEventValueChanged];
        
        [self toolTateBar];
        
        [self addSubview:datePicker];
       
        
        
    }
    return self;
}


+(TCDatePickerView *)initWithPicker:(CGRect )viewFrame
{
    return [[self alloc]initWithFrame:viewFrame];
    
}


+(TCDatePickerView *)initWithPicker
{
    return [[self alloc]init];
    
}

//自定义时间格式，获得当前时间
+(NSString *)getNowDateFormat:(NSString *)date
{
    NSDate * selected = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:date];
    
    NSString * selectDate = [dateFormatter stringFromDate:selected];
    
    return selectDate;
}


//获取当前时间选择器上的时间
-(NSString *)getNowDatePicker:(NSString *)date
{
    
    NSDate * selected = [datePicker date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:date];
    
    NSString * selectDate = [dateFormatter stringFromDate:selected];
    
    return selectDate;
    
    
}


//显示时间选择器
-(void) popDatePickerView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = CGRectMake(0, viewFrame.size.height - 256, viewFrame.size.width, 256);
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
}


//隐藏时间选择器
-(void) hiddenDatePickerView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = CGRectMake(0, viewFrame.size.height, viewFrame.size.width, 256);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//设置是否隐藏
-(void) datePickerWillHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (hidden)
        {
            
            self.frame = CGRectMake(0, viewFrame.size.height, viewFrame.size.width, 256);
        }
        else
        {
           // self.hidden = hidden;
            self.frame = CGRectMake(0, viewFrame.size.height - 256, viewFrame.size.width, 256);
        }
        
        
    } completion:^(BOOL finished) {
        
        [self setHidden:hidden];
        
    }];
    
}


//再次点击timeLable按钮时，重设时间为当前时间
-(void)resetToZero
{

    [datePicker setDate:[NSDate date] animated:YES];

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
    
    
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewFrame.size.width - 68, 5, 60, 30)];
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


//取消选择时间
-(void)cancelDate:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCancelSelectDate)])
    {
        [self.delegate didCancelSelectDate];
    }
    //#warning 取消时，恢复原来时间
    [self hiddenDatePickerView];
    
}


//保存选择的时间
-(void)saveDate:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSaveDate)])
    {
        [self.delegate didSaveDate];
    }
    
    [self hiddenDatePickerView];
    
}


//值改变时
-(void)didDateChange
{
    
    if ([self.delegate respondsToSelector:@selector(didDateChangeTo)])
    {
        [self.delegate didDateChangeTo];
    }



}

@end
