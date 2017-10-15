//
//  TCEditDiaryView.m
//  SecurityNote
//
//  Created by HTC on 14-9-29.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCEditDiaryView.h"
#import "TCDiary.h"
#import "TCDatePickerView.h"
#import "MBProgressHUD+MJ.h"

@interface TCEditDiaryView ()<TCDatePickerViewDelegate,UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView * detailView;

@property (nonatomic, strong) TCDiary * editNote;

@property (nonatomic, weak) UILabel * dateLabel;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, weak) UITextField * weatherField;
@property (nonatomic, weak) UITextField * moodField;

@property (nonatomic, copy) NSString * originalDate;

@end

@implementation TCEditDiaryView

-(TCDiary *)editNote
{
    if (_editNote == nil)
    {
        _editNote = [[TCDiary alloc]init];
    }
    return _editNote;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        UITextField * titleField = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 20, 35)];
        titleField.font = [UIFont boldSystemFontOfSize:23];
        titleField.textAlignment = NSTextAlignmentCenter;
        titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.titleField = titleField;
        //        titleField.layer.borderWidth = 2;
        //        titleField.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] CGColor];
        
        
        UITextView * detailView =[[UITextView alloc]initWithFrame:CGRectMake(10, 110, self.view.frame.size.width - 20, self.view.frame.size.height - 110)];
        detailView.font = [UIFont systemFontOfSize:18];
        
        detailView.layer.borderWidth = 1.5;
        detailView.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] CGColor];
        detailView.layer.cornerRadius = 4.0f;
        detailView.layer.masksToBounds = YES;
        detailView.alwaysBounceVertical = YES;
        self.detailView = detailView;
        self.detailView.delegate = self;
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleBordered target:self action:@selector(beginEdit:)];
        
        rightItem.tintColor = [UIColor whiteColor];
        
        [self.navigationItem setRightBarButtonItem:rightItem];
        
        
        //时间标签
        [self showdateLabel];
        
        self.dateLabel.hidden = YES;
        
        //天气标签
        [self showWeather];
        
        self.weatherField.hidden = YES;
        
        //心情标签
        [self showMood];
        
        self.moodField.hidden = YES;
        
        //放这里，盖住时间、天气、心情，使文档在最上面
        [self.view addSubview:titleField];
        [self.view addSubview:detailView];
        
        //时间选择器 !!!必须放在最后，点击时，可以显示出来
        self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
        self.pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.editNote = [self.editNote queryOneNote:self.ids];
    
    self.titleField.text = self.editNote.title;
    
    self.detailView.text = self.editNote.content;
  
    self.titleField.enabled = NO;
    self.detailView.editable = NO;
    
    
}


-(void)beginEdit:(id)sender
{
    
    //进入编辑模式
    if ([[sender title] isEqualToString:@"修改"])
    {
        [UIImageView animateWithDuration:0.3 animations:^{
            
            self.detailView.frame = CGRectMake(10, 135, self.view.frame.size.width - 20, self.view.frame.size.height - 135);
            
            
            self.dateLabel.text = [self.editNote.time substringFromIndex:5];
            self.weatherField.text = self.editNote.weather;
            self.moodField.text = self.editNote.mood;
            
            self.dateLabel.hidden = NO;
            self.weatherField.hidden = NO;
            self.moodField.hidden = NO;
            
        } completion:^(BOOL finished)
        {
            self.titleField.enabled = YES;
            self.detailView.editable = YES;
            [self.titleField becomeFirstResponder];
            
            self.navigationItem.rightBarButtonItem.title = @"保存";
        }];
        
    }
    else //保存
    {
        //标题不能空
        if ([self.titleField.text length] == 0)
        {
            [MBProgressHUD showError:@"密官！标题不能空啊😱😱"];
            
            return ;
        }
        
        [UIImageView animateWithDuration:0.3 animations:^{
           
            self.dateLabel.hidden = YES;
            self.weatherField.hidden = YES;
            self.moodField.hidden = YES;
            
            self.detailView.frame = CGRectMake(10, 110, self.view.frame.size.width - 20, self.view.frame.size.height - 110);
            
            //隐藏时间选择器
            [self.pickerView hiddenDatePickerView];
            [self.view endEditing:YES];
    
        } completion:^(BOOL finished)
        {
            self.titleField.enabled = NO;
            self.detailView.editable = NO;
            self.navigationItem.rightBarButtonItem.title = @"修改";
            
            self.editNote.title = self.titleField.text;
            self.editNote.content = self.detailView.text;
            //self.editNote.time = self.dateLabel.text;
            self.editNote.weather = self.weatherField.text;
            self.editNote.mood = self.moodField.text;
            
            //保存到数据库中
            [self.editNote updataNote:self.editNote];
            
        }];
        
    }
    
}


//时间标签
-(void)showdateLabel
{
    
    UILabel * dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 120, 15)];
    dateLabel.font = [UIFont systemFontOfSize:16];
    // dateLabel.userInteractionEnabled = YES;
    self.dateLabel = dateLabel;
    [self.view addSubview:dateLabel];
    
    //提供点击显示时间选择器
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(10, 110, 120, 20)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:touchLabel];
    
}



//时间选择器
-(void)showPicker
{
    
    self.originalDate = self.dateLabel.text;
    
    [self.pickerView popDatePickerView];
    
    //点击DateLable时，归零(到现在的时间）
    [self.pickerView resetToZero];
    
    
    [self.view endEditing:YES];
    
}


//天气标签
-(void)showWeather
{
    UITextField * weatherField = [[UITextField alloc]initWithFrame:CGRectMake(130, 108,  (self.view.frame.size.width -135)/ 2, 20)];
    weatherField.font = [UIFont systemFontOfSize:16];
    weatherField.placeholder = @"现在的天气";
    weatherField.textAlignment = NSTextAlignmentCenter;
    weatherField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.weatherField = weatherField;
    
    [self.view addSubview:weatherField];
    
}


//心情标签
-(void)showMood
{
    UITextField * moodField = [[UITextField alloc]initWithFrame:CGRectMake( 135 +(self.view.frame.size.width -135)/ 2, 108, (self.view.frame.size.width -135)/ 2, 20)];
    moodField.font = [UIFont systemFontOfSize:16];
    moodField.placeholder = @"我的心情";
    moodField.textAlignment = NSTextAlignmentCenter;
    moodField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.moodField = moodField;
    
    [self.view addSubview:moodField];
    
}


//取消时间选择器
-(void)didCancelSelectDate
{
    self.dateLabel.text = self.originalDate;
}


//保存时间选择
-(void)didSaveDate
{
    self.dateLabel.text = [self.pickerView getNowDatePicker:@"M月d日 HH:mm"];
    self.editNote.time = [self.pickerView getNowDatePicker:@"yyyy年M月d日 HH:mm"];

}


//改变时间选择
-(void)didDateChangeTo
{
    self.dateLabel.text = [self.pickerView getNowDatePicker:@"M月d日 HH:mm"];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.view endEditing:YES];
    
    //隐藏时间选择器
    [self.pickerView hiddenDatePickerView];
}


//设置代理后，点击return，响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    //隐藏时间选择器
    [self.pickerView hiddenDatePickerView];
    
}



@end
