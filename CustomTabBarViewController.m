//
//  CustomTabBarViewController.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController
@synthesize buttons;
@synthesize slideView;
@synthesize currentSelectIndex;
@synthesize imageView;

-(void)viewWillAppear:(BOOL)animated
{
    nameImage = [[NSMutableArray alloc] initWithObjects:@"图标11.png",@"图标12.png",@"图标13.png",@"图标14.png", nil];
    NSString *str = [nameImage objectAtIndex:self.selectedIndex];
    slideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 49)];
    slideView.image = [UIImage imageNamed:str];
    [self hideTabBar];
    [self customTabBar];
}

//隐藏TabBar的视图
-(void)hideTabBar
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
}

-(void)customTabBar
{
    UIView *groundView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    UIColor *tabBarColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"标题栏背景.png"]];
    [groundView setBackgroundColor:tabBarColor];
    [tabBarColor release];
    //将groundView加载到self.view上
    [self.view insertSubview:groundView atIndex:1];
    
    //创建button
    int count = self.viewControllers.count > 5 ? 5:self.viewControllers.count;
    self.buttons = [NSMutableArray arrayWithCapacity:count];
    float width = 320/count;
    float heigth = self.tabBar.frame.size.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, heigth);
        [button addTarget:self action:@selector(selectedTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, heigth - 22, width, heigth - 22)];
        [label setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *iView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
        iView.image = [UIImage imageNamed:[NSString stringWithFormat:@"图标%d.png",i + 1]];
        [button addSubview:iView];
        [iView release];
        
        switch (i) {
            case 0:
            {
                [label setText:@"我的收藏"];
                break;
            }   
            case 1:
            {
                [label setText:@"自选位置"];
                break;
            }
            case 2:
            {
                [label setText:@"当前位置"];
                break;
            }
                case 3:
            {
                [label setText:@"更多"];
                break;
            }
        }
        
        label.textColor = [UIColor colorWithRed:70/255.0 green:30/255.0 blue:26/255.0 alpha:1.0];
        [label setFont:[UIFont systemFontOfSize:12.0]];
		[label setTextAlignment:UITextAlignmentCenter];
		[button addSubview:label];
		[label release];
        
        [self.buttons addObject:button];
		[groundView addSubview:button];
    }
    [groundView release];
    [self selectedTabBarItem:[self.buttons objectAtIndex:self.selectedIndex]];
}

-(void)selectedTabBarItem:(UIButton *)button
{
    if ([imageView superview]) {
        [imageView removeFromSuperview];
    }
    if ([lab superview]) {
        [lab removeFromSuperview];
    }
    int i = button.tag; 
    float width = button.frame.size.width;
    float height = button.frame.size.height;
    self.currentSelectIndex = button.tag;
    self.selectedIndex = self.currentSelectIndex;
    [self performSelector:@selector(slideTabBarItem:) withObject:imageView];
	if (self.currentSelectIndex == i) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"图标1%d.png",button.tag+1]];
        [button addSubview:imageView];
        [imageView release];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0,height-22, width, height-22)];
        
        switch (i) {
            case 0:
            {
                [lab setText:@"我的收藏"];
                break;
            }   
            case 1:
            {
                [lab setText:@"自选位置"];
                break;
            }
            case 2:
            {
                [lab setText:@"当前位置"];
                break;
            }
            case 3:
            {
                [lab setText:@"更多"];
                break;
            }
        }

        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
		[lab setFont:[UIFont systemFontOfSize:12.0]];
		[lab setTextAlignment:UITextAlignmentCenter];
		[button addSubview:lab];
        [lab release];
	}
}

-(void)slideTabBarItem:(UIImageView *)image
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:0.2];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
        
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
