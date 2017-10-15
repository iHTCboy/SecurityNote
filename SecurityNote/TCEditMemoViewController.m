//
//  TCEditMemoViewController.m
//  SecurityNote
//
//  Created by HTC on 14-9-30.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCEditMemoViewController.h"
#import "TCDatePickerView.h"
#import "TCMemo.h"
#import "MBProgressHUD+MJ.h"
#import "TCYearPickerView.h"

@interface TCEditMemoViewController ()<TCDatePickerViewDelegate,TCYearPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UITextField * titleField;
@property (nonatomic, weak) UITextView  * detailView;
@property (nonatomic, weak) UITextField * memotypeF;
@property (nonatomic, weak) UILabel * yearL;
@property (nonatomic, weak) UILabel * timeL;

@property (nonatomic, strong) TCMemo * editNote;
@property (nonatomic, strong) TCDatePickerView * pickerView;
@property (nonatomic, strong) TCYearPickerView * yearPickerV;

@property (nonatomic, strong) NSMutableArray * yearArray;

@end

@implementation TCEditMemoViewController

-(TCMemo *)editNote
{
    if (_editNote == nil)
    {
        _editNote = [[TCMemo alloc]init];
    }
    return _editNote;
}


//自定义年份picker
-(NSMutableArray *)yearArray
{
    if (_yearArray == nil)
    {
        _yearArray = [NSMutableArray array];
        
        for (int j = 0; j < 100; j ++)
        {
            NSString * yearStr = [NSString stringWithFormat:@"2%03d年",j];
            
            [self.yearArray addObject:yearStr];
        }
        
    }
    return _yearArray;
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
        [self showTime];
        self.timeL.hidden = YES;
        
        //年份标签
        [self showYear];
        self.yearL.hidden = YES;
        
        //备忘类型标签
        [self showMemoType];
        self.memotypeF.hidden = YES;
        
        
        //放这里，盖住时间、天气、心情，使文档在最上面
        [self.view addSubview:titleField];
        [self.view addSubview:detailView];
        
        
        //时间选择器 !!!必须放在最后，点击时，可以显示出来
        self.pickerView = [TCDatePickerView initWithPicker:self.view.frame];
        self.pickerView.delegate = self;
        [self.view addSubview:self.pickerView];
        
        
        self.yearPickerV = [TCYearPickerView initWithPicker:self.view.frame];
        //TCYearPickerView的代理
        self.yearPickerV.delegate = self;
        [self.view addSubview:self.yearPickerV];
        
        
        //pickerView的代理
        self.yearPickerV.yearPickers.delegate = self;
        self.yearPickerV.yearPickers.dataSource = self;
        
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
            
            
            self.timeL.text = self.editNote.time;
            self.yearL.text = self.editNote.year;
            self.memotypeF.text = self.editNote.memotype;
            
            self.timeL.hidden = NO;
            self.yearL.hidden = NO;
            self.memotypeF.hidden = NO;
            
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
            
            self.timeL.hidden = YES;
            self.yearL.hidden = YES;
            self.memotypeF.hidden = YES;
            
               self.detailView.frame = CGRectMake(10, 110, self.view.frame.size.width - 20, self.view.frame.size.height - 110);
            
            //隐藏时间选择器
            [self.pickerView hiddenDatePickerView];
            [self.yearPickerV hiddenYearPickerView];
            [self.view endEditing:YES];
            
        } completion:^(BOOL finished)
         {
             self.titleField.enabled = NO;
             self.detailView.editable = NO;
             self.navigationItem.rightBarButtonItem.title = @"修改";
             
             self.editNote.title = self.titleField.text;
             self.editNote.content = self.detailView.text;
             //self.editNote.time = self.timeL.text;
             self.editNote.memotype = self.memotypeF.text;
             //self.editNote.year = self.yearL.text;
             
             //保存到数据库中
             [self.editNote updataNote:self.editNote];
             
         }];
        
    }
    
}


//年份标签
-(void)showYear
{
    UILabel * yearL = [[UILabel  alloc]initWithFrame:CGRectMake(10, 108, 60, 15)];
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textAlignment = NSTextAlignmentCenter;
    self.yearL = yearL;
    
    [self.view addSubview:yearL];
    
    //提供点击显示时间选择器
    UIButton * touchYearL = [[UIButton alloc]initWithFrame:CGRectMake(10, 108, 60, 15)];
    
    [touchYearL addTarget:self action:@selector(showYearPicker) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:touchYearL];
    
}


//年份选择器
-(void)showYearPicker
{
    //隐藏时间选择器，显示年份选择器
    [self.pickerView hiddenDatePickerView];
    [self.yearPickerV popYearPickerView];
    
    
    //默认选中原来备忘的年份
    NSRange oldYear;
    oldYear.length = 2;
    oldYear.location = 2;
    [self.yearPickerV.yearPickers selectRow:[[self.editNote.year substringWithRange:oldYear] intValue] inComponent:0 animated:YES];
    
    [self.view endEditing:YES];
    
}


//时间标签
-(void)showTime
{
    
    UILabel * timeL =[[UILabel alloc]initWithFrame:CGRectMake(70, 108, 120, 15)];
    timeL.font = [UIFont systemFontOfSize:16];
    // dateLabel.userInteractionEnabled = YES;
    self.timeL = timeL;
    [self.view addSubview:timeL];
    
    //提供点击显示时间选择器
    UIButton * touchLabel = [[UIButton alloc]initWithFrame:CGRectMake(70, 108, 120, 15)];
    [touchLabel addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:touchLabel];
    
}



//时间选择器
-(void)showPicker
{
    
    //隐藏年份选择器，显示时间选择器
    [self.yearPickerV hiddenYearPickerView];
    [self.pickerView popDatePickerView];

    
    [self.pickerView popDatePickerView];
    
    //点击DateLable时，归零(到现在的时间）
    [self.pickerView resetToZero];
    
    
    [self.view endEditing:YES];
    
}



//备忘类型标签
-(void)showMemoType
{
   UITextField * memotypeF = [[UITextField alloc]initWithFrame:CGRectMake(190, 108, self.view.frame.size.width - 190, 20)];
    memotypeF.font = [UIFont systemFontOfSize:16];
    memotypeF.placeholder = @"备忘类型";
    memotypeF.textAlignment = NSTextAlignmentCenter;
    memotypeF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.memotypeF = memotypeF;
    
    [self.view addSubview:memotypeF];
    
}


//取消时间选择器
-(void)didCancelSelectDate
{
    self.timeL.text = self.editNote.time;
}


//保存时间选择
-(void)didSaveDate
{
    self.editNote.time = self.timeL.text;
    
}


//改变时间选择
-(void)didDateChangeTo
{
    self.timeL.text = [self.pickerView getNowDatePicker:@"M月d日 HH:mm"];
}




//取消年份选择器
-(void)didCancelSelectYear
{
    self.yearL.text = self.editNote.year;
}


//保存年份选择
-(void)didSaveYear
{
    self.editNote.year = self.yearL.text;
    
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


//包含多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


//包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearArray.count;
}


//指定列表和列表项的标题文本
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.yearArray objectAtIndex:row];
    
}


//选中列表时，激发
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.yearL.text = [self.yearArray objectAtIndex:row];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    //隐藏时间选择器
    [self.pickerView hiddenDatePickerView];
    [self.yearPickerV hiddenYearPickerView];
    
}



@end
