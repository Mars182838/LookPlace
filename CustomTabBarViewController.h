//
//  CustomTabBarViewController.h
//  _LookForPlace
//
//  Created by Ibokan on 12-10-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarViewController : UITabBarController
{
    NSMutableArray *buttons;
    NSArray *nameImage;
    UIImageView *imageView;
    UIImageView *slideView;
    UILabel *lab;
    int currentSelectIndex;
}

@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *slideView;
@property (nonatomic, assign) int currentSelectIndex;

-(void)hideTabBar;
-(void)customTabBar;
-(void)selectedTabBarItem:(UIButton *)button;

@end
