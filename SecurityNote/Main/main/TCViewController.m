//
//  TCViewController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-11.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCViewController.h"

@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //状态栏为白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    
    //改变系统的导航栏
    UINavigationBar * navBar = [UINavigationBar appearance];
    
    //导航栏背影色
    [navBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1]];
    
    //导航栏标题为白色
    [navBar setBarStyle:UIBarStyleBlack];

    //导航栏返回条颜色
    navBar.tintColor = [UIColor whiteColor];
    
    
    //设置BarButtonItem的主题
    UIBarButtonItem * item = [UIBarButtonItem appearance];
    
    NSMutableDictionary * itemAttrys = [NSMutableDictionary dictionary];
    
    itemAttrys[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //itemAttrys [NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [item setTitleTextAttributes:itemAttrys forState:UIControlStateNormal];
    
    //tab bar 颜色
//    UITabBar * tabBar = [UITabBar appearance];
//    tabBar.tintColor = [UIColor redColor];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
