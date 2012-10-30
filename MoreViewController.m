//
//  MoreViewController.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "FuWuViewController.h"
#import "OpinionViewController.h"
#import "InfomationViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            //推到帮助界面
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
            [view setBackgroundColor:[UIColor clearColor]];
            [self performSelector:@selector(helpful)];
            [self.view addSubview:view];
            [view release];
            break;
        }   
        case 1:
        {
            //进入到意见界面
            OpinionViewController *opinion = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController" bundle:nil];
            [self.navigationController pushViewController:opinion animated:YES];
            [opinion release];
            break;
        }
        case 2:
        {
            //496407433
            //进入appstore
            NSString *str = [NSString stringWithFormat:
                             @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=496407433&mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            break;
        }
        case 3:
        {
            //推到信息页面
            InfomationViewController *information = [[InfomationViewController alloc] initWithNibName:@"InfomationViewController" bundle:nil];
            [self.navigationController pushViewController:information animated:YES];
            [information release];
            break;
        }
        case 4:
        {
        //返回到RootViewController中
            [self dismissViewControllerAnimated:YES completion:^(){  }];
            break;
        }
            
    }
}

-(void)helpful
{
    FuWuViewController *help = [[FuWuViewController alloc] init];
    [self presentViewController:help animated:YES completion:^(){ }];
    [help release];
}

@end
