//
//  TCSimpleNoteTool.m
//  SecurityNote
//
//  Created by HTC on 14-9-22.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//


#import "TCSimpleNoteTool.h"
#import "TCSimpleNote.h"
#import "FMDB.h"

@implementation TCSimpleNoteTool

static FMDatabaseQueue *_queue;

+ (void)initialize
{
    // 1.获得沙盒中的数据库文件名
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来
   NSString *path  = [documentFolderPath stringByAppendingPathComponent:@"SecurityNote.sqlite"];
    
    //2. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //3. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:path];
    //- (BOOL)fileExistsAtPath:(NSString *)path;
    
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        //拷贝数据库
        
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
    NSString *backupDbPath = [[NSBundle mainBundle]pathForResource:@"SecurityNote.sqlite" ofType:nil];

        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        [fm copyItemAtPath:backupDbPath toPath:path error:nil];
    }
    
    
   // TCLog(@"%@",path);
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
//    if (![_queue open]) {
//        NSLog(@"数据库打开失败！");
//    }

}



//查询
+(NSMutableArray *)queryWithSql
{
    __block TCSimpleNote * datanote;
    
    // 1.定义数组
    __block NSMutableArray *dictArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db)
     {
        
        // 创建数组
        dictArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
       
        rs = [db executeQuery:@"select * from simplenote"];
        
        while (rs.next)
        {
            datanote = [[TCSimpleNote alloc]init];
            datanote.ids = [rs intForColumn:@"ids"];
            datanote.count = [rs intForColumn:@"count"];
            
            
        NSMutableArray * oneData = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < datanote.count; i++)
            {
               
                [oneData addObject:[rs stringForColumnIndex:i+2]];
                
            }
            
        [datanote.datas addObject:oneData];
            
        [dictArray addObject:datanote];
            
        }
    }];
    
    // 3.返回数据
    return dictArray;
}



//更新
+ (void)upDateWithString:(NSString *)string forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_queue inDatabase:^(FMDatabase *db)
    {
        
        NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%ld = ? WHERE ids = %ld;",(long)[indexPath row],(long)[indexPath section]];
        
        [db executeUpdate:upDate,string];
        
    }];
}


//插入
+(void)insertDatas:(TCSimpleNote *)addNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
        FMResultSet *rs = nil;
        
        //查询数据库中有几组数据
        rs = [db executeQuery:@"select count(*) from simplenote"];
        int counts = 0;
        if (rs.next)
        {
            counts = [rs intForColumnIndex:0];
        }
        [rs close];
        
        
        // 2.存储数据
            for (int i = 0; i < addNote.count; i++)
            {
                //第一条是插入语句
                if(i == 0)
                {
                    
                NSString * upDate = [NSString stringWithFormat:@"insert into simplenote(ids, count, tc%d) values (?, ?, ?)",i];
                    
                [db executeUpdate:upDate,[NSNumber numberWithInt:counts],[NSNumber numberWithInt:addNote.count], [addNote.datas objectAtIndex:0]];
                }
                else  //其它就是更新
                {
                   NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;",i,counts];
                    [db executeUpdate:upDate,[addNote.datas objectAtIndex:i]];
                }
            }
        
        }];
}


//删除一列，做法是重新插入更新原列表
+(void)deleteString:(TCSimpleNote *)deleteStr
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         //这里是大数组（多条列表记录）中的一个数组（一条列表）
         NSMutableArray * counts = [deleteStr.datas objectAtIndex:0];
         deleteStr.count = (int)[counts count];
         
         //如果只剩下最后一条，直接删除，然后把后面的ids往前增加
         if(deleteStr.count == 0)
         {
             [db executeUpdate:@"delete from simplenote where ids = ?", [NSNumber numberWithInt:deleteStr.ids]];
             
            //查询数据库中有几组数据
             FMResultSet *rs = nil;
             rs = [db executeQuery:@"select count(*) from simplenote"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0];
             }
             [rs close];
             
             //重新排列ids顺序
             for (int i = 0; i < counts - deleteStr.ids ; i++)
             {
                 [db executeUpdate:@"update simplenote set ids = ? where ids = ?", [NSNumber numberWithInt:(deleteStr.ids + i)],[NSNumber numberWithInt:(deleteStr.ids + i + 1)]];
             }

         }
         else //不是只剩下一条的列表，进行删除对应列
         {
             for (int i = 0; i < deleteStr.count; i++)
             {
                 //第一条是更新count和tc0
                 if(i == 0)
                 {
                     NSString * upDate = [NSString stringWithFormat:@"update simplenote set count = ? , tc%d = ? where ids = %d;", i, deleteStr.ids];
                     
                     [db executeUpdate:upDate,[NSNumber numberWithInt:deleteStr.count], [[deleteStr.datas objectAtIndex:0] objectAtIndex:i]];
                 }
                 else  //其它就是更新
                 {
                     NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;", i, deleteStr.ids];
                     [db executeUpdate:upDate,[[deleteStr.datas objectAtIndex:0] objectAtIndex:i]];
                 }
             }
         }
         
     }];

}


//一条一条的插入更新
+(void)upDateInsert:(TCSimpleNote *)upDateInsert
{

    [_queue inDatabase:^(FMDatabase *db)
     {
         
         // 1.存储数据
         for (int i = 0; i < upDateInsert.count; i++)
         {
             //第一条是插入语句
             if(i == 0)
             {
                 NSString * upDate = [NSString stringWithFormat:@"update simplenote set count = ? , tc%d = ? where ids = %d ;",i,upDateInsert.ids];
                 
                 [db executeUpdate:upDate,[NSNumber numberWithInt:upDateInsert.count],               [[upDateInsert.datas objectAtIndex:0]objectAtIndex:0]];
             }
             else  //其它就是更新
             {
                 NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;",i,upDateInsert.ids];
                 
                 [db executeUpdate:upDate,[[upDateInsert.datas objectAtIndex:0]objectAtIndex:i]];
             }
         }
         
     }];

}


@end
