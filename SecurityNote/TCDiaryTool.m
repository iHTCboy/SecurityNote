//
//  TCDiaryTool.m
//  SecurityNote
//
//  Created by HTC on 14-9-28.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCDiaryTool.h"
#import "TCDiary.h"
#import "FMDB.h"
@implementation TCDiaryTool


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
    __block TCDiary * datanote;
    
    // 1.定义数组
    __block NSMutableArray *diaryArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db)
     {
         
         // 创建数组
         diaryArray = [NSMutableArray array];
         
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from securitynote"];
         
         while (rs.next)
         {
            
             datanote = [[TCDiary alloc]init];
            
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.time = [rs stringForColumn:@"time"];
             datanote.weather = [rs stringForColumn:@"weather"];
             datanote.mood = [rs stringForColumn:@"mood"];
             
             [diaryArray addObject:datanote];
             
         }
     }];
    
    // 3.返回数据
    return diaryArray;
}

//删除一条
+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
        
      [db executeUpdate:@"delete from securitynote where ids = ?", [NSNumber numberWithInt:ids]];
     }];
}


//插入一条
+(void)insertNote:(TCDiary *)diaryNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into securitynote(title, content, time, weather, mood) values (?, ?, ?, ?, ?)",diaryNote.title, diaryNote.content, diaryNote.time, diaryNote.weather, diaryNote.mood];
     }];
}

//查询一条对应ids的数据
+(TCDiary *)queryOneNote:(int)ids
{
    __block TCDiary * datanote;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db)
     {
       
         FMResultSet *rs = nil;
         
         rs = [db executeQuery:@"select * from securitynote where ids = ?",[NSNumber numberWithInt:ids]];
         
         while (rs.next)
         {
             datanote = [[TCDiary alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.time = [rs stringForColumn:@"time"];
             datanote.weather = [rs stringForColumn:@"weather"];
             datanote.mood = [rs stringForColumn:@"mood"];
             
         }
     }];
    
    // 3.返回数据
    return datanote;
}


//更新一条
+(void)updataNote:(TCDiary *)updataNote
{

    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update securitynote set title = ? , content = ?, time = ?, weather = ? , mood = ? where ids = ? ;",updataNote.title, updataNote.content, updataNote.time, updataNote.weather, updataNote.mood, [NSNumber numberWithInt:updataNote.ids]];

     }];
}



@end
