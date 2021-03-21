//
//  TCDiaryViewController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-15.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCDiaryViewController.h"
#import "TCAddDiaryViewController.h"
#import "TCDiary.h"
#import "TCDatePickerView.h"
#import "TCEditDiaryView.h"
#import "DHDeviceUtil.h"

@interface TCDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>

//主表格
@property (nonatomic, weak) UITableView * diaryTable;

//全部数据库条数
@property (nonatomic, strong) NSMutableArray * diaryLists;

//一条TCDiary数据
@property (nonatomic, strong) TCDiary * diaryNote;

//增加按钮
@property (nonatomic, weak) UIButton * addBtn;


@end

@implementation TCDiaryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    
    UITableView * dairyTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    dairyTab.separatorColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    dairyTab.rowHeight = 60;
    
    dairyTab.delegate = self;
    dairyTab.dataSource = self;
    
    self.diaryTable = dairyTab;
    [self.view addSubview:dairyTab];
    
    dairyTab.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"tableView": dairyTab};
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:widthConstraints];
    [NSLayoutConstraint activateConstraints:heightConstraints];
    
    CGFloat top = (MACRO_IS_IPHONE_X ? 150 : 120);
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, self.view.frame.size.height - top,  48, 48)];
    [addBtn setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addNew:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    self.addBtn = addBtn;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.addBtn addGestureRecognizer:pan];
    
    addBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *addViews = NSDictionaryOfVariableBindings(addBtn);
    NSArray *addWidthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[addBtn(>=48,<=60)]-20-|" options:0 metrics:nil views:addViews];
    NSArray *addHeightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[addBtn(>=48,<=60)]-120-|" options:0 metrics:nil views:addViews];
    [NSLayoutConstraint activateConstraints:addWidthConstraints];
    [NSLayoutConstraint activateConstraints:addHeightConstraints];
    
    self.diaryLists = [self.diaryNote queryWithNote];
    
}


//懒加载
-(TCDiary *)diaryNote
{
    if (_diaryNote == nil)
    {
        _diaryNote = [[TCDiary alloc]init];
    }
    
    return _diaryNote;
}


//保存新建的简记后，重新刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    //    switch (pan.state) {
    //        case UIGestureRecognizerStateBegan: // 开始触发手势
    //
    //            break;
    //
    //        case UIGestureRecognizerStateEnded: // 手势结束
    //
    //            break;
    //
    //        default:
    //            break;
    //    }
    
    // 1.在view上面挪动的距离
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    
    // 2.清空移动的距离
    [pan setTranslation:CGPointZero inView:pan.view];
}


//点击增加按钮，进入添加简记
-(void)addNew:(UIImageView* )add
{
    [UIImageView animateWithDuration:0.3 animations:^{
        
        add.layer.transform = CATransform3DMakeScale(2, 2, 0);
        add.alpha = 0;
    }
    completion:^(BOOL finished)
     {
         TCAddDiaryViewController *toAddController = [[TCAddDiaryViewController alloc]init];
        [toAddController viewDidColseCompletion:^{
            //必须重新查询数据库更新数据
            self.diaryLists = [self.diaryNote queryWithNote];
            [self.diaryTable reloadData];
        }];
         [self presentViewController:toAddController animated:YES completion:^{
             
             add.layer.transform = CATransform3DIdentity;
             add.alpha = 1;

             
         }];
         
     }];
    
}


//列表数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.diaryLists count];
}


//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * diaryID = @"diaryID";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:diaryID];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:diaryID];
        if (@available(iOS 13.0, *)) {
            cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        }
    }
    

    //cell被选中的颜色
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TCCoror(51, 149, 253);
    //右侧的指示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //当前分区的数据
    self.diaryNote = self.diaryLists[[indexPath row]];
    
    cell.textLabel.text = self.diaryNote.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:23];
//    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    
    //判断时间，如果是今年，那么只显示月日; 如果不是，显示年份
    NSString * times = [self.diaryNote.time substringToIndex:4];
    NSString * detailContent;
    if ([times isEqualToString:[TCDatePickerView getNowDateFormat:@"yyyy"]])
    {
         detailContent = [NSString stringWithFormat:@"%@    %@    %@", [self.diaryNote.time substringFromIndex:5], self.diaryNote.weather, self.diaryNote.mood];
    }
    else
    {
        detailContent = [NSString stringWithFormat:@"%@    %@    %@",self.diaryNote.time, self.diaryNote.weather, self.diaryNote.mood];
    }
    

    cell.detailTextLabel.text = detailContent;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
        
    return cell;
    
}



//编辑状态
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.diaryNote = [self.diaryLists objectAtIndex:[indexPath row]];
        
        [self.diaryNote deleteNote:self.diaryNote.ids];
        
        [self.diaryLists removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}



//选择的列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     TCEditDiaryView * editController = [[TCEditDiaryView alloc]init];
    
     self.diaryNote = self.diaryLists[[indexPath row]];
    
     editController.ids = self.diaryNote.ids;

    
    self.hidesBottomBarWhenPushed = YES;
    
     [self.navigationController pushViewController:editController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.addBtn.hidden = YES;
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.addBtn.hidden = NO;
    
    return YES;
}


@end
