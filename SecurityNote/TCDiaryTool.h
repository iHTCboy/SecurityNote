//
//  TCDiaryTool.h
//  SecurityNote
//
//  Created by HTC on 14-9-28.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCDiary;

@interface TCDiaryTool : NSObject


+(NSMutableArray *)queryWithNote;

+(void)deleteNote:(int)ids;

+(void)insertNote:(TCDiary *)diaryNote;

+(TCDiary *)queryOneNote:(int)ids;

+(void)updataNote:(TCDiary *)updataNote;

@end
