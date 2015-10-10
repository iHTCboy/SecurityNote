//
//  TCSimpleNoteTool.h
//  SecurityNote
//
//  Created by HTC on 14-9-22.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCSimpleNote;

@interface TCSimpleNoteTool : NSObject


+ (NSMutableArray *)queryWithSql;

+ (void)upDateWithString:(NSString*)string forRowAtIndexPath:(NSIndexPath *)indexPath;

+ (void)insertDatas:(TCSimpleNote *)addNote;

+ (void)deleteString:(TCSimpleNote *)deleteStr;

+ (void)upDateInsert:(TCSimpleNote *)upDateInsert;

@end
