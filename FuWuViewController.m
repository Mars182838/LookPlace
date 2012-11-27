//
//  FuWuViewController.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FuWuViewController.h"
#import "RootViewController.h"
#import "CustomTabBarViewController.h"
#define numberPic 5

@interface FuWuViewController ()

@end

@implementation FuWuViewController


#pragma mark - View  lifecycle

- (void)loadView
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    [view release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView setContentSize:CGSizeMake(320 * numberPic,0)];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < numberPic; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [imageview setBackgroundColor:[UIColor whiteColor]];
        [imageview setBackgroundColor:[UIColor whiteColor]];
        switch (i) {
            case 0:
            {
                [imageview setImage:[UIImage imageNamed:@"fu1.jpg"]];
                break;
            }
            case 1:
            {
                [imageview setImage:[UIImage imageNamed:@"fu2.jpg"]];
                break;
            }
            case 2:
            {
                [imageview setImage:[UIImage imageNamed:@"fu3.jpg"]];
                break;
            }
            case 3:
            {
                [imageview setImage:[UIImage imageNamed:@"fu4.jpg"]];
                break;
            }
            case 4:
            {
                [imageview setImage:[UIImage imageNamed:@"fu5.jpg"]];
                break;
            }
        }
        [scrollView addSubview:imageview];
        [imageview release];
    }
    
    UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFuWuShiTu:)];
    tapGesturer.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:tapGesturer];
    [scrollView release];
}

-(void)removeFuWuShiTu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

@end
