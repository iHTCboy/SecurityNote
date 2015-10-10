//
//  TCMemoTool.m
//  SecurityNote
//
//  Created by HTC on 14-9-30.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCMemoTool.h"
#import "TCMemo.h"
#import "FMDB.h"

@implementation TCMemoTool


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
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    //    if (![_queue open]) {
    //        NSLog(@"数据库打开失败！");
    //    }
    
}


//查询
+(NSMutableArray *)queryWithNote
{
    __block TCMemo * datanote;
    
    // 1.定义数组
    __block NSMutableArray *memoArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         // 创建数组
         memoArray = [NSMutableArray array];
         
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from memonote"];
         
         while (rs.next)
         {
             
             datanote = [[TCMemo alloc]init];
             
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.memotype = [rs stringForColumn:@"memotype"];
             datanote.year = [rs stringForColumn:@"year"];
             datanote.time = [rs stringForColumn:@"time"];
             
             [memoArray addObject:datanote];
             
         }
     }];
    
    // 3.返回数据
    return memoArray;
}

//删除一条
+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         [db executeUpdate:@"delete from memonote where ids = ?", [NSNumber numberWithInt:ids]];
     }];
}


//插入一条
+(void)insertNote:(TCMemo *)memoNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into memonote(title, content, memotype, year, time) values (?, ?, ?, ?, ?)",memoNote.title, memoNote.content, memoNote.memotype, memoNote.year, memoNote.time];
     }];
}

//查询一条对应ids的数据
+(TCMemo *)queryOneNote:(int)ids
{
    __block TCMemo * datanote;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from memonote where ids = ?",[NSNumber numberWithInt:ids]];
         
         while (rs.next)
         {
             datanote = [[TCMemo alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.memotype = [rs stringForColumn:@"memotype"];
             datanote.year = [rs stringForColumn:@"year"];
             datanote.time = [rs stringForColumn:@"time"];
             
         }
     }];
    
    // 3.返回数据
    return datanote;
}


//更新一条
+(void)updataNote:(TCMemo *)updataNote
{
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update memonote set title = ? , content = ?, memotype = ?, year = ? , time = ? where ids = ? ;",updataNote.title, updataNote.content, updataNote.memotype, updataNote.year, updataNote.time, [NSNumber numberWithInt:updataNote.ids]];
     }];
}



@end
