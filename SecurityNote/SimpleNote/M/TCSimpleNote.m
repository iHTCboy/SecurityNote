//
//  TCSimpleNote.m
//  SecurityNote
//
//  Created by HTC on 14-9-22.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCSimpleNote.h"
#import "TCSimpleNoteTool.h"

@implementation TCSimpleNote

//懒加载！
-(NSMutableArray *)datas
{

    if (_datas == nil)
    {
        _datas = [NSMutableArray array];
        
    }
    
    return _datas;
    
}



-(NSMutableArray *)queryWithData
{
    return [TCSimpleNoteTool queryWithSql];
}


-(void)upDateString:(NSString *)string forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TCSimpleNoteTool upDateWithString:string forRowAtIndexPath:indexPath];

}

-(void)insertDatas:(TCSimpleNote *)addNote
{

    [TCSimpleNoteTool insertDatas:addNote];
}


-(void)deleteString:(TCSimpleNote *)deleteStr
{

    [TCSimpleNoteTool deleteString:deleteStr];

}

-(void)upDateInsert:(TCSimpleNote *)upDateInsert
{
    [TCSimpleNoteTool upDateInsert:upDateInsert];
    
}

@end
