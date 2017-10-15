//
//  TCHelpViewController.m
//  SecurityNote
//
//  Created by HTC on 14-10-2.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCHelpViewController.h"

@interface TCHelpViewController ()<UIActionSheetDelegate>

@end

@implementation TCHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    self.title = @"帮助";
    
    UIImageView * logoV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoabout.png"]];
    logoV.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.21);
    logoV.bounds = CGRectMake(0, 0, 120, 120);
    logoV.layer.cornerRadius = 25;
    logoV.layer.masksToBounds = YES;
    [self.view addSubview:logoV];
    
    
    UILabel * name = [[UILabel alloc]init];
    name.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.33);
    name.bounds = CGRectMake(0, 0, 100, 80);
    name.text = @"密记";
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:name];
    
    
    UILabel * thank = [[UILabel alloc]init];
    thank.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.45);
    thank.bounds = CGRectMake(0, 0,280, 80);
    thank.text = @"真诚的感谢您使用密记！";
    thank.textAlignment = NSTextAlignmentCenter;
    thank.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:thank];
    
    
    UILabel * user = [[UILabel alloc]init];
    user.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.55);
    user.bounds = CGRectMake(0, 0,280, 80);
    user.numberOfLines = 0;
    user.text = @"如果您在使用过程中，有任何疑问或者意见，欢迎访问密记:";
    user.textAlignment = NSTextAlignmentCenter;
    user.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:user];
    
    
    UIButton * goUrl = [[UIButton alloc]init];
    goUrl.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.7);
    goUrl.bounds = CGRectMake(0, 0,200, 30);
    [goUrl setTitle:@"访问密记" forState:UIControlStateNormal];
    [goUrl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goUrl setTitleColor:TCCoror(186, 186, 192) forState:UIControlStateDisabled];
    goUrl.adjustsImageWhenHighlighted = NO;
    [goUrl addTarget:self action:@selector(goWeb) forControlEvents:UIControlEventTouchUpInside];
    goUrl.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    goUrl.layer.cornerRadius = 3.5;
    goUrl.layer.masksToBounds = YES;
    goUrl.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    [self.view addSubview:goUrl];

    
    
    UILabel * htc = [[UILabel alloc]init];
    htc.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.96);
    htc.bounds = CGRectMake(0, 0, 250, 80);
    htc.text = @"@iHTCboy All Rights";
    htc.textAlignment = NSTextAlignmentCenter;
    htc.textColor = TCCoror(147, 147, 147);
    htc.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:htc];
    
    
    UILabel * rights = [[UILabel alloc]init];
    rights.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.98);
    rights.bounds = CGRectMake(0, 0, 250, 80);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    rights.text = [NSString stringWithFormat:@"©2014-%@ iNotes @iHTCboy All rights reserved", yearString];
    rights.textAlignment = NSTextAlignmentCenter;
    rights.textColor = TCCoror(147, 147, 147);
    rights.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:rights];

}


-(void)goWeb
{
    UIActionSheet * sheets = [[UIActionSheet alloc]initWithTitle:@"通过Safari,选择您想要访问的网页" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"作者微博",@"作者博客", nil];
    
    sheets.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [sheets showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSURL * url = [NSURL URLWithString:@"http://weibo.com/iHTCapp"];
        
        [[UIApplication sharedApplication] openURL:url];
       
    }
    else if(buttonIndex == 1)
    {
        NSURL * url = [NSURL URLWithString:@"http://www.ihtc.cc"];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }

    


}

@end
