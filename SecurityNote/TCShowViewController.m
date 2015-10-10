//
//  TCShowViewController.m
//  GLUTJWsystem
//
//  Created by joonsheng on 14-8-27.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCShowViewController.h"

#define showImageCount 5

@interface TCShowViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation TCShowViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = showImageCount;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 55;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
      pageControl.currentPageIndicatorTintColor =[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    pageControl.pageIndicatorTintColor = TCCoror(130, 130, 130);
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index< showImageCount; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name = nil;
        if (fourInch)
        { // 4inch
            
            name = [NSString stringWithFormat:@"4%d", index + 1];
            
        }
        else if(fiveInch)
        {
            name = [NSString stringWithFormat:@"5%d", index + 1];
        }
        else if(sixInch)
        {
            name = [NSString stringWithFormat:@"6%d", index + 1];
        }
        else
        {
            name = [NSString stringWithFormat:@"6p%d", index + 1];
        }

        imageView.image = [UIImage imageNamed:name];
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == showImageCount - 1)
        {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * showImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}

/**
 *  添加内容到最后一个图片
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 0.让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
 
    [startButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1]];
    
    startButton.layer.cornerRadius = 3.5;
    startButton.layer.masksToBounds = YES;
    
    // 2.设置frame
    CGFloat centerX = imageView.frame.size.width * 0.5;
    CGFloat centerY = imageView.frame.size.height * 0.85;
    startButton.center = CGPointMake(centerX, centerY);
    startButton.frame = CGRectMake(self.view.frame.size.width * 0.1, self.view.center.y * 1.4, self.view.frame.size.width * 0.8, 35);
    

    // 3.设置文字
    [startButton setTitle:@"开始密记" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
   
}


/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

/**
 *  进入登陆界面
 */
- (void)start
{
    [UIView animateWithDuration:1 animations:^{
        
        // 切换窗口的根控制器
        UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = [stryBoard instantiateInitialViewController];
        
    }];

}


@end