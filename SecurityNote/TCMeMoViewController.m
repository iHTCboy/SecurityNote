//
//  TCMeMoViewController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-15.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCMeMoViewController.h"
#import "TCAddMemoViewController.h"
#import "TCMemo.h"
#import "TCDatePickerView.h"
#import "TCEditMemoViewController.h"

@interface TCMeMoViewController ()<UITableViewDelegate,UITableViewDataSource>

//主表格
@property (nonatomic, weak) UITableView * memoTable;

//全部数据库条数
@property (nonatomic, strong) NSMutableArray * memoLists;

//一条TCDiary数据
@property (nonatomic, strong) TCMemo * memoNote;

@property (nonatomic, weak) UIButton * addBtn;

@end

@implementation TCMeMoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    
    UITableView * memoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    memoTable.separatorColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    memoTable.rowHeight = 60;
    
    memoTable.delegate = self;
    memoTable.dataSource = self;
    
    self.memoTable = memoTable;
    [self.view addSubview:memoTable];
    
    
    UIButton * add = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, self.view.frame.size.height - 120,  48, 48)];
    [add setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addNew:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    
    self.addBtn = add;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.addBtn addGestureRecognizer:pan];
    
    
    self.memoLists = [self.memoNote queryWithNote];
    
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

//懒加载
-(TCMemo *)memoNote
{
    if (_memoNote == nil)
    {
        _memoNote = [[TCMemo alloc]init];
    }
    
    return _memoNote;
}


//保存新建的简记后，重新刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //必须重新查询数据库更新数据
    self.memoLists = [self.memoNote queryWithNote];
    [self.memoTable reloadData];
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
         TCAddMemoViewController *toAddController = [[TCAddMemoViewController alloc]init];
         
         [self presentViewController:toAddController animated:YES completion:^{
             
             add.layer.transform = CATransform3DIdentity;
             add.alpha = 1;

         }];
         
     }];
    
}


//列表数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.memoLists count];
}


//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * diaryID = @"diaryID";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:diaryID];
    
    if (cell == nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:diaryID];
        
    }
    
    
    //cell被选中的颜色
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TCCoror(51, 149, 253);
    //右侧的指示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //当前分区的数据
    self.memoNote = self.memoLists[[indexPath row]];
    
    cell.textLabel.text = self.memoNote.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:23];
    //    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@    %@",self.memoNote.year, self.memoNote.time, self.memoNote.memotype];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
    
}



//编辑状态
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.memoNote = [self.memoLists objectAtIndex:[indexPath row]];
        
        [self.memoNote deleteNote:self.memoNote.ids];
        
        [self.memoLists removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}



//选择的列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCEditMemoViewController * editController = [[TCEditMemoViewController alloc]init];
    
    self.memoNote = self.memoLists[[indexPath row]];
    
    editController.ids = self.memoNote.ids;
    
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
