//
//  TCDiary.h
//  SecurityNote
//
//  Created by HTC on 14-9-28.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDiary : NSObject

@property (nonatomic, assign) int ids;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * time;

@property (nonatomic, copy) NSString * weather;

@property (nonatomic, copy) NSString * mood;

-(NSMutableArray *)queryWithNote;

-(void)deleteNote:(int)ids;

-(void)insertNote:(TCDiary *)diaryNote;

-(TCDiary *)queryOneNote:(int)ids;

-(void)updataNote:(TCDiary *)updataNote;

@end
