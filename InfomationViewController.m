//
//  InfomationViewController.m
//  LookPlace
//
//  Created by Ibokan on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InfomationViewController.h"
#import "MoreViewController.h"

@interface InfomationViewController ()

@end

@implementation InfomationViewController

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
    UIScrollView *scrollV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 357)];
    [scrollV setContentSize:CGSizeMake(0, 704)];
    [self.view addSubview:scrollV];
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 704)];
    [imageV setImage:[UIImage imageNamed:@"版本信息1.png"]];
    [scrollV addSubview:imageV];
    [scrollV release];
    [imageV release];
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
    
    MoreViewController *more = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    [self.navigationController pushViewController:more animated:YES];
    [more release];
}

@end
