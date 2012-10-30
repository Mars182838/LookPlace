//
//  OpinionViewController.m
//  LookPlace
//
//  Created by Ibokan on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OpinionViewController.h"
#import "Const.h"
#import "URLEncode.h"

@interface OpinionViewController ()

@end

@implementation OpinionViewController
@synthesize opinionLabel;
@synthesize email;
@synthesize numberLabel;
@synthesize opinionTextView;
@synthesize emailTextField;
@synthesize toolbar;

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
    emailTextField.delegate = self;
    opinionTextView.delegate = self;
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, toolBarHeight)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:toolbar];
    [hiddenButtonItem release];
    [spaceButtonItem release];
    [toolbar release]; 
    
    self.opinionTextView.inputAccessoryView = toolbar;
    self.emailTextField.inputAccessoryView = toolbar;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.returnKeyType = UIReturnKeyDone;
    //注册键盘开始弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//隐藏键盘的按钮的方法
-(void)HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [self.opinionTextView resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [UIView setAnimationDuration:0.3f];
    toolbar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [UIView commitAnimations];
}
//监控将要出现键盘的方法
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    toolbar.frame = CGRectMake(0, 416-kbSize.height, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}

//监控键盘消失的方法
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolbar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0, -125,WIDTH,HEIGHT);//上移80个单位，按实际情况设置
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect=CGRectMake(0,0,WIDTH,HEIGHT);//上移80个单位，按实际情况设置
    self.view.frame = rect;
    [UIView commitAnimations];
    toolbar.frame = CGRectMake(0, HEIGHT, WIDTH, 44);
    [self.emailTextField resignFirstResponder];
    return YES;
}

#pragma mark 
#pragma mark UITextView Delegate 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect=CGRectMake(0,-70,WIDTH,HEIGHT);//上移80个单位，按实际情况设置
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0,0,WIDTH,HEIGHT);//上移80个单位，按实际情况设置
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    int a = 500 - self.opinionTextView.text.length;
    NSNumber * Num = [[NSNumber alloc] initWithInt:a];
    self.numberLabel.text = [NSString stringWithFormat:@"还可以输入%@个字",Num];
    if (a == 0) {
        [self.opinionTextView resignFirstResponder];
    }
    [Num release];
}

- (void)viewDidUnload
{
    [self setOpinionLabel:nil];
    [self setEmail:nil];
    [self setNumberLabel:nil];
    [super viewDidUnload];
  
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
            //返回moreViewController界面
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }   
        case 1:
        {
            NSRegularExpression *regulare = [[NSRegularExpression alloc] initWithPattern:@"[a-zA-Z0-9]+@[a-zA-Z0-9]+[\\.[a-zA-Z0-9]+]+" options:NSRegularExpressionCaseInsensitive error:nil];
            NSUInteger number = [regulare numberOfMatchesInString:self.emailTextField.text options:NSMatchingReportProgress range:NSMakeRange(0, self.emailTextField.text.length)];
            [regulare release];
            if (number > 0) {
                NSString *postString = [NSString stringWithFormat:@"act=advise&dev=ios&ver=1.1&email=%@&advise=%@",self.emailTextField.text,[URLEncode encodeUrlStr:self.opinionLabel.text]];
                NSURL *url = [NSURL URLWithString:@"http://ibokan.gicp.net/ibokan/map/map.php"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
                coonection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                if (coonection) {
                    mutableData = [[NSMutableData data] retain];
                }
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"感谢您的宝贵意见" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alter show];
                [alter release];
            }
            else {
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"您输入的邮箱不正确,请输入正确的邮箱" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alterView show];
                [alterView release];
            }
            break;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * str = [NSString stringWithCString:[mutableData bytes] encoding:NSASCIIStringEncoding];
    NSLog(@"str = %@",str);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)dealloc {
    [opinionLabel release];
    [email release];
    [numberLabel release];
    [emailTextField release];
    [opinionTextView release];
    [super dealloc];
}
@end
