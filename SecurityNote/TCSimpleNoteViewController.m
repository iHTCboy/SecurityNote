//
//  TCSimpleNoteViewController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-15.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCSimpleNoteViewController.h"
#import "TCAddSimpleNoteViewController.h"
#import "TCSimpleNote.h"


@interface TCSimpleNoteViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

//为了方便全局刷新
@property (nonatomic, weak) UITableView * simpleTable;

//增加按钮
@property (nonatomic, weak) UIButton * addBtn;

//确定当前所选的IndexPath
@property (nonatomic, strong) NSIndexPath * nowIndexPath;

//全部的数据，以数组对象封装的TCSimpleNote模型
@property (nonatomic, strong) NSMutableArray * noteDatas;

//一个TCSimpleNote模型
@property (nonatomic, strong) TCSimpleNote * TCnote;

//保存未插入新列表时的临时模型
@property (nonatomic, strong) NSMutableArray * insertIndexPaths;

//保存移动的列表的indexPath
@property (nonatomic, strong) NSMutableArray * moveRowIndexpaths;

//判断是删除模式（0），还是插入和移动模式（1）
@property (nonatomic, assign) int editMode;


@property (nonatomic, assign) float oldY;

@end

@implementation TCSimpleNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    
    //列表
    UITableView * simpleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height + 10) style:UITableViewStylePlain];
    simpleTable.separatorColor = TCCoror(51, 149, 253);
    //simpleTable.separatorInset = UIEdgeInsetsMake(0, -100, 0, 0);
    simpleTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    simpleTable.delegate = self;
    simpleTable.dataSource = self;
    self.simpleTable = simpleTable;
    [self.view addSubview:simpleTable];

    
    //增加按钮
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, self.view.frame.size.height - 120,  48, 48)];
    [addBtn setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addNew:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    [self.view addSubview:addBtn];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.addBtn addGestureRecognizer:pan];
    
    
    //查询数据库，获取数据库全部的记录
    self.noteDatas = [self.TCnote queryWithData];

    //判断是删除模式（0），还是插入和移动模式（1）
    self.editMode = 0;
    
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
-(TCSimpleNote *)TCnote
{
    if (_TCnote == nil)
    {
        _TCnote = [[TCSimpleNote alloc]init];
    }

    return _TCnote;

}

//懒加载
-(NSMutableArray *)insertIndexPaths
{
    if (_insertIndexPaths == nil)
    {
        _insertIndexPaths = [NSMutableArray array];
    }
    
    return _insertIndexPaths;
    
}

//懒加载
-(NSMutableArray *)moveRowIndexpaths
{
    if (_moveRowIndexpaths == nil)
    {
        _moveRowIndexpaths = [NSMutableArray array];
    }
    
    return _moveRowIndexpaths;
    
}


//保存新建的简记后，重新刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //必须重新查询数据库更新数据
    self.noteDatas = [self.TCnote queryWithData];
    [self.simpleTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{

        self.tabBarController.tabBar.hidden = NO;

}

//增加一个列表简记
-(void)addNew:(UIImageView* )add
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        add.layer.transform = CATransform3DMakeScale(2, 2, 0);
        add.alpha = 0;
    }
    completion:^(BOOL finished)
     {
         TCAddSimpleNoteViewController *toAddController =[[TCAddSimpleNoteViewController alloc]init];
         
         [self presentViewController:toAddController animated:YES completion:^{
             
             add.layer.transform = CATransform3DIdentity;
             add.alpha = 1;
             
         }];
         
     }];
    
}


//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.noteDatas count];

}


//每个分区的列数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.TCnote = self.noteDatas[section];
    return self.TCnote.count;
    
}


//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * simpleID = @"simpleID";
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:simpleID];
    if (cell == nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleID];
    
    }
    
    //cell被选中的颜色
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = TCCoror(51, 149, 253);
    //cell.separatorInset = UIEdgeInsetsMake(0, -50, 0, -50);
   
    //当前分区的数据
    self.TCnote = self.noteDatas[[indexPath section]];
    
    cell.textLabel.text =[[self.TCnote.datas objectAtIndex:0]objectAtIndex:[indexPath row]];
    
    
    //[cell setSelected:NO];
    //cell.showsReorderControl = YES;
 

    //首行大字体
    if (indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:23];
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    
    return cell;
}



//列表的编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //侧滑是编辑时，进入插入和移动编辑模式
    if ([indexPath row]  == 0  && [tableView numberOfRowsInSection:[indexPath section]] != 1 )
    {
        self.addBtn.hidden = YES;
        
        //!!!!暂时通过刷新更新 移动图标
        [self.simpleTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

        self.editMode = 1;
        [self.simpleTable setEditing:YES animated:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEdit)];
        
        //刷新列表
        //[tableView reloadData];
        [self.simpleTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    }
    
    //删除列表项
    if (editingStyle == UITableViewCellEditingStyleDelete && self.editMode == 0)
    {
        
       //拿到当前要删除的列表的所在分区
        self.TCnote = self.noteDatas[[indexPath section]];
        
        //更改列表文字
        [[self.TCnote.datas objectAtIndex:0] removeObjectAtIndex:[indexPath row]];
        
        //更新数据库
        [self.TCnote deleteString:self.TCnote];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新列表
        [self.simpleTable reloadData];
        
    }
    
    //增加列表项
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        //拿到当前要删除的列表的所在分区
         self.TCnote = self.noteDatas[[indexPath section]];
        
        //更改列表文字
        [[self.TCnote.datas objectAtIndex:0] insertObject:@"新简记" atIndex:[indexPath row] + 1 ];
        
        //重点！！要增加counto数
        self.TCnote.count = self.TCnote.count + 1;
        
        
        //保存插入新列表时的，插入过那些区
        if (self.insertIndexPaths.count == 0)
        {
            [self.insertIndexPaths addObject:indexPath];
        }
        else
        {
            //记录当前比较的次数，如果次数等于当前数据的数量，说明当前插入的区别是新区
            int key = 0;
            
            for (int i =0 ; i < self.insertIndexPaths.count ; i++)
            {
                //获取i时的数组里的分区号
                NSIndexPath * insertPath = [self.insertIndexPaths objectAtIndex:i];
                
                if (self.insertIndexPaths.count == 1 && [insertPath section] != [indexPath section])
                {
                    [self.insertIndexPaths addObject:indexPath];
                    
                    break;

                }
                
                if ( [insertPath section] != [indexPath section])
                {
                     key ++;
                    
                }
                
                
                if ( key == self.insertIndexPaths.count )
                {
                    [self.insertIndexPaths addObject:indexPath];

                }
            }
        }
        
       [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新列表
        [self.simpleTable reloadData];

    }
}


//取消编辑
-(void)cancelEdit
{
    
    //！！！重新查询数据库，还原全部的记录
    self.noteDatas = [self.TCnote queryWithData];
    
    self.addBtn.hidden = NO;
    
    //清空保存插入的分区记录
    self.insertIndexPaths = nil;
    
    self.editMode = 0;
    self.simpleTable.editing = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.simpleTable reloadData];

 
}


//完成编辑，保存操作后数据到数据库
-(void)finishEdit
{

    //一、更新【插入】操作，保存到数据库
    for (int i =0 ; i < self.insertIndexPaths.count; i++)
    {
        //拿到插入过的当前列表的所在分区
        NSIndexPath * insertPath = [self.insertIndexPaths objectAtIndex:i];
    
        self.TCnote = self.noteDatas[[insertPath section]];

        //更新数据库
        [self.TCnote upDateInsert:self.TCnote];
    
    }

    
    //二、更新【移动】操作，保存到数据库
    for (int i = 0; i < self.moveRowIndexpaths.count; i++)
    {
        //取出当前i时的源目的indexPath数组
        NSArray * indexPaths = [self.moveRowIndexpaths objectAtIndex:i];
        NSIndexPath * source = [indexPaths objectAtIndex:0];
        NSIndexPath * dest = [indexPaths objectAtIndex:1];
        
        if(source.row == dest.row && source.section == dest.section)
        {
            //源和目的indexPath一样，不操作
        }
        else
        {
            //1、获取移动的文字
            TCSimpleNote * sourceNote = self.noteDatas[[source section]];
            
            NSString * sourceStr = [[sourceNote.datas objectAtIndex:0] objectAtIndex:[source row]];
            
            //2、删除原位置
            //2.1、删除当前要删除的列表的文字
            [[sourceNote.datas objectAtIndex:0] removeObjectAtIndex:[source row]];
    
            //2.2、更新数据库
            [sourceNote deleteString:sourceNote];
            
            
            //3、插入到新位置
            //3.1、更改列表文字
            TCSimpleNote * destNote = self.noteDatas[[dest section]];
            
            [[destNote.datas objectAtIndex:0] insertObject:sourceStr atIndex:[dest row]];
            
            //3.2、重点！！要增加counto数
            destNote.count = destNote.count + 1;
            
            //3.4、更新数据库
            [destNote upDateInsert:destNote];
        }
        
    }

    
    self.addBtn.hidden = NO;

    //清空保存插入的分区记录
    self.insertIndexPaths = nil;
    //清空保存的移动的分区记录
    self.moveRowIndexpaths = nil;
    
    self.editMode = 0;
    self.simpleTable.editing = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.simpleTable reloadData];

}


//移动完成时，激发该方法
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //保存源和目的indexPath到数据中，如果用户点击完成，才保存到数据库
    NSArray * sourceAndDest = [[NSArray alloc]initWithObjects:sourceIndexPath,destinationIndexPath, nil];
    
    [self.moveRowIndexpaths addObject:sourceAndDest];
    
}


//选择是删除或插入编辑模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editMode == 0)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else if([indexPath row] == 0 && self.editMode == 1)
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleInsert;
    
    }
    
}


//侧滑时，显示的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.addBtn.hidden = YES;
    
    if([indexPath row] == 0 &&
       [tableView numberOfRowsInSection:[indexPath section]] != 1)
    {
        return @"编辑";
    }
    else
    {
        return @"删除";
    }
}


//cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editMode == 0)
    {
        self.addBtn.hidden = NO;
    }
    else
    {
        self.addBtn.hidden = YES;
    
    }
    
    return YES;
}


//cell可移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//列表的选择项
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nowIndexPath = indexPath;
    
    self.TCnote = self.noteDatas[[indexPath section]];
    
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"编辑" message:@"请输入内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alter.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //拿到当前选中列表的文字
    [alter textFieldAtIndex:0].text = [[self.TCnote.datas objectAtIndex:0]objectAtIndex:[indexPath row]];

    //显示文本框的x
    [alter textFieldAtIndex:0].clearButtonMode =UITextFieldViewModeWhileEditing;
    
    [alter show];
}



//alertView方法调用,需要实现UIAlertViewDelegate协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self.simpleTable deselectRowAtIndexPath:self.nowIndexPath animated:YES];
    }
    
    if (buttonIndex == 1)
    {
        [self.simpleTable deselectRowAtIndexPath:self.nowIndexPath animated:YES];
        
        //拿到当前要编辑的列表的所在分区
        self.TCnote = self.noteDatas[[self.nowIndexPath section]];
        
        //更改列表文字
        [[self.TCnote.datas objectAtIndex:0] replaceObjectAtIndex:(self.nowIndexPath.row) withObject:[alertView textFieldAtIndex:0].text];
        
        //更新数据库
        [self.TCnote upDateString:[alertView textFieldAtIndex:0].text forRowAtIndexPath:self.nowIndexPath];
        
        //刷新列表
        [self.simpleTable reloadData];
    }
    
}


//如果是首行，就高一些
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        
        return 60;
    }
    return 40;

}


//每个分区的列表底部的大小
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;

}


//列表的底部颜色
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * colorView = [[UIView alloc]init];
    colorView.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:0.8];
    return colorView;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
     static float newY = 0;

     newY = scrollView.contentOffset.y;
    
    if (newY != _oldY)
    {
        //向下滚动
        if (newY > _oldY && (newY - _oldY) > 0)
        {
            //TCLog(@"%f",(_oldY - newY));
            self.tabBarController.tabBar.hidden = YES;
            self.simpleTable.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height + 50);
            _oldY = newY;
            
        }
        else if (newY < _oldY && (_oldY - newY) > 100)
        {
            
            self.tabBarController.tabBar.hidden = NO;
            self.simpleTable.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height + 10);
            _oldY = newY;
        }
    
    }
}

@end
