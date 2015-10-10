//
//  TCAbutSNoteViewController.m
//  SecurityNote
//
//  Created by HTC on 14-10-1.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCAbutSNoteViewController.h"

@interface TCAbutSNoteViewController ()

@end

@implementation TCAbutSNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关于";
    
    UIImageView * logoV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoabout.png"]];
    logoV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.4);
    logoV.bounds = CGRectMake(0, 0, 120, 120);
    [self.view addSubview:logoV];
    
    
    UILabel * name = [[UILabel alloc]init];
    name.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.55);
    name.bounds = CGRectMake(0, 0, 50, 80);
    name.text = @"密记";
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:name];
    
    
    UILabel * version = [[UILabel alloc]init];
    version.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.59);
    version.bounds = CGRectMake(0, 0, 180, 80);
    version.text = @"密记iPhone版1.2";
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:version];
    
    UILabel * htc = [[UILabel alloc]init];
    htc.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.96);
    htc.bounds = CGRectMake(0, 0, 250, 80);
    htc.text = @"何天从 版权所有";
    htc.textAlignment = NSTextAlignmentCenter;
    htc.textColor = TCCoror(147, 147, 147);
    htc.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:htc];
    

    UILabel * rights = [[UILabel alloc]init];
    rights.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.98);
    rights.bounds = CGRectMake(0, 0, 250, 80);
    rights.text = @"© 2014-2015 hetiancong All rights reserved";
    rights.textAlignment = NSTextAlignmentCenter;
    rights.textColor = TCCoror(147, 147, 147);
    rights.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:rights];


}



@end
