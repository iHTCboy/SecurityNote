//
//  TCMemoTool.h
//  SecurityNote
//
//  Created by HTC on 14-9-30.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCMemo;

@interface TCMemoTool : NSObject

+(NSMutableArray *)queryWithNote;

+(void)deleteNote:(int)ids;

+(void)insertNote:(TCMemo *)memoNote;

+(TCMemo *)queryOneNote:(int)ids;

+(void)updataNote:(TCMemo *)updataNote;


@end
