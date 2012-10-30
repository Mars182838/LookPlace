//
//  ShareWeiboViewController.m
//  ShareWeibo
//
//  Created by Ibokan on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareWeiboViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation ShareWeiboViewController
@synthesize musicStr = _musicStr;
@synthesize textView = _textView;
@synthesize picker = _picker;

-(void)viewDidLoad
{
    [super viewDidLoad];
    tencentOAuthManager = [[OAuthManager alloc] initWithOAuthManager:TENCENT_WEIBO];

//    self.title = @"我的微博分享主页";
//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 150.0f)];
//    _textView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
//    _textView.editable = NO;
//    _textView.text = _musicStr;
//    [self.view addSubview:_textView];
//  
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230.0f, 0.0f, 100.0f, 30.0f)];
//    label.text = @"图片预览";
//    [self.view addSubview:label];
//    [label release];
//    
//    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    titleBtn.frame = CGRectMake(20.0f, 170.0f, 70.0f, 40.0f);
//    titleBtn.showsTouchWhenHighlighted = YES;
//    [titleBtn setTitle:@"分享文字" forState:UIControlStateNormal];
//    [titleBtn addTarget:self action:@selector(shareTitle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:titleBtn];
//    
//    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    imageBtn.frame = CGRectMake(100.0f, 170.0f, 70.0f, 40.0f);
//    imageBtn.showsTouchWhenHighlighted = YES;
//    [imageBtn setTitle:@"分享图片" forState:UIControlStateNormal];
//    [imageBtn addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:imageBtn];
//    
//    UIButton *allWeiboBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    allWeiboBtn.frame = CGRectMake(180.0f, 170.0f, 130.0f, 40.0f);
//    allWeiboBtn.showsTouchWhenHighlighted = YES;
//    [allWeiboBtn setTitle:@"获取所有的微博" forState:UIControlStateNormal];
//    [allWeiboBtn addTarget:self action:@selector(acceptAllweibo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:allWeiboBtn];
//    
    //点击UIimageView会自动调出相册
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(210.0f, 30.0f, 100.0f, 110.0f)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.userInteractionEnabled = YES;
    myImageView = imageView; 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGesture:)];
    [myImageView addGestureRecognizer:tap];
    [tap release];
    [self.view addSubview:myImageView];
    [imageView release];
//    
//    UIBarButtonItem *enterBtn = [[UIBarButtonItem alloc] initWithTitle:@"登陆微博"
//                                                                 style:UIBarButtonItemStylePlain 
//                                                                target:self 
//                                                                action:@selector(enterWeibo)];
//    self.navigationItem.rightBarButtonItem = enterBtn;
//    [enterBtn release];
}

-(void)enterWeibo
{
    //负责弹出腾讯的登陆界面，以网页的形式弹出来
    [tencentOAuthManager login];
    return;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求结束");
    if ([request tag] == 101) {
        NSLog(@"这是干嘛用的啊");
        NSLog(@"post text weibo is %@",[request responseString]);
    }else if([request tag] == 102){
        NSLog(@"post pic weibo is %@",[request responseString]);
    }else if([request tag] == 100){
        NSLog(@"all weibo is %@",[request responseString]);
    }
}


- (void) shareTencentTextClick:(id)sender {
    if (![tencentOAuthManager isAlreadyLogin]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"还没有账号登陆" message:@"请登陆腾讯微博" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [av show];
        [av release];
        return;
    }
    
    // https://open.t.qq.com/api/t/add
    NSString *path = [NSString stringWithFormat:@"%@/%@", [tencentOAuthManager getOAuthDomain], @"t/add"];
    NSURL *url = [NSURL URLWithString:path];
    
    ASIFormDataRequest *postTextWeibo = [ASIFormDataRequest requestWithURL:url];
    NSString *text = self.textView.text;
    NSLog(@"text is %@",text);
    [postTextWeibo setPostValue:@"json" 
                         forKey:@"format"];
    [postTextWeibo setPostValue:text 
                         forKey:@"content"];
    [postTextWeibo setPostValue:@"40.034753" 
                         forKey:@"wei"];
    [postTextWeibo setPostValue:@"116.311435" 
                         forKey:@"jing"];
    [postTextWeibo setPostValue:@"0" 
                         forKey:@"syncflag"];
    [postTextWeibo setPostValue:@"221.223.249.130" 
                         forKey:@"clientip"];
    
    [tencentOAuthManager addPrivatePostParamsForASI:postTextWeibo];
    
    [postTextWeibo setDelegate:self];
    [postTextWeibo setTag:101];
    [postTextWeibo startAsynchronous];
}


-(void)shareTitle:(id)sender
{
    [self shareTencentTextClick:sender];
}

-(void)shareTencentPicClick:(id)sender
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"图片分享" message:@"图片分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"cancle", nil];
    [alter show];
    [alter release];
    UIImage *image = [myImageView image];
    NSString *text = [self.textView text];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    //照片是jpeg格式
    NSString *path = [NSString stringWithFormat:@"%@/%@",[tencentOAuthManager getOAuthDomain],@"t/add_pic"];
    NSURL *url = [NSURL URLWithString: path];
    
    ASIFormDataRequest *postPicWeibo = [ASIFormDataRequest requestWithURL:url];
    
    [postPicWeibo setPostValue:@"json" forKey:@"format"];
    [postPicWeibo setPostValue:text forKey:@"content"];
    [postPicWeibo addData:data withFileName:@"test2xx.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    [postPicWeibo setPostValue:@"40.034753" forKey:@"wei"];
    [postPicWeibo setPostValue:@"116.311435" forKey:@"jing"];
    [postPicWeibo setPostValue:@"0" forKey:@"syncflag"];
    [tencentOAuthManager addPrivatePostParamsForASI:postPicWeibo];
    
    [postPicWeibo setDelegate:self];
    [postPicWeibo setTag:102];
    [postPicWeibo startAsynchronous];
}


-(void)shareImage:(id)sender
{
    [self shareTencentPicClick:sender];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    myImageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];

}

-(void)clickGesture:(UITapGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [ipc setDelegate:self];
        [self presentModalViewController:ipc animated:YES];
        [ipc release];
    }
}

-(NSURL *)generateURL:(NSString *)baseURL params:(NSDictionary *)params
{
    if (params) {
        NSMutableArray *pairs = [NSMutableArray array];
        for (NSString *key in params.keyEnumerator) {
            NSString *value = [params objectForKey:key];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        NSString *query = [pairs componentsJoinedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@?%@",baseURL,query];
        return [NSURL URLWithString:url];
    }
    else{
    
        return  [NSURL URLWithString:baseURL];
    }
}

/* http://open.t.qq.com/api_docs/20_84.html
 腾讯weibo头像，图片不可用的解决方法  Fuck Tencent
 5.头像地址不可用
 在返回的头像地址后面加上 /20 /30 /40 /50 /100 返回相应大小的图片。
 6.图片地址不可用
 返回图片地址请在后面加上 /120 /160 /460 /2000。
 */
- (void) getAllTencentWeiboClick:(id)sender {
    // https://open.t.qq.com/api/statuses/home_timeline
    NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"json", @"format",
                                    @"0", @"pageflag",
                                    @"0", @"contenttype",
                                    @"0", @"pagetime",
                                    @"10", @"reqnum",
                                    nil];
    NSDictionary *privDict = [tencentOAuthManager getCommonParams];
    [params addEntriesFromDictionary:privDict];
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@", [tencentOAuthManager getOAuthDomain], @"statuses/home_timeline"];
    NSURL *url = [self generateURL:baseUrl params:params];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSLog(@"url=%@",url);
    [request setDelegate:self];
    [request setTag:100];
    [request startAsynchronous];
}

- (void) acceptAllweibo:(id)sender 
{
    [self getAllTencentWeiboClick:sender];
}

@end
