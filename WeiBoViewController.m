
#import "WeiBoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PlaceMessageViewController.h"

@interface WeiBoViewController ()

@end

@implementation WeiBoViewController
@synthesize textView = _textView;
@synthesize picker = _picker;
@synthesize shareString;
@synthesize toolBar;

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
    tencentOAuthManager = [[OAuthManager alloc] initWithOAuthManager:TENCENT_WEIBO];
    //点击UIimageView会自动调出相册
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 120.0f, 105.0f, 120.0f)];
    imageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    imageView.userInteractionEnabled = YES;
    myImageView = imageView; 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGesture:)];
    [myImageView addGestureRecognizer:tap];
    [tap release];
    [self.view addSubview:myImageView];
    [imageView release];
    
    self.textView.delegate = self;
    self.textView.text = self.shareString;
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,HEIGHT,WIDTH,toolBarHeight)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:toolBar];
    [spaceButtonItem release];
    [hiddenButtonItem release];
    
    //键盘弹出时注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘退出时注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘弹出时的方法
-(void)keyboardWillShow:(NSNotification *)notification
{
   [self.textView resignFirstResponder];
    NSDictionary *info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    toolBar.frame = CGRectMake(0, 510-kbSize.height, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}
//键盘退出时的方法
-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    toolBar.frame = CGRectMake(0, HEIGHT, WIDTH,toolBarHeight);
    [UIView commitAnimations];
}

//toolBar上面的按钮点击方法
-(void) HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.textView resignFirstResponder];
    toolBar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    self.view.frame = CGRectMake(0, 0, 320, 480);
    [UIView commitAnimations];
}
#pragma mark - 
#pragma mark ShareWiBo Methods
//微博登入界面
-(void)enterWeibo
{
    //负责弹出腾讯的登陆界面，以网页的形式弹出来
    [tencentOAuthManager login];
    return;
}
//分享微博方法
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
    [postPicWeibo setPostValue:@"39.907404" forKey:@"wei"];
    [postPicWeibo setPostValue:@"116.191801" forKey:@"jing"];
    [postPicWeibo setPostValue:@"0" forKey:@"syncflag"];
    [tencentOAuthManager addPrivatePostParamsForASI:postPicWeibo];
    
    [postPicWeibo setDelegate:self];
//    [postPicWeibo setTag:102];
    [postPicWeibo startAsynchronous];
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

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"post pic weibo is %@",[request responseString]);
}

#pragma mark - 
#pragma mark UIImagePicker Delegate Methods 
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
//获取图片
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

#pragma mark - 
#pragma mark UITextView Delegate Methods
//textView开始编辑时调用
- (BOOL)textViewShouldBeginEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    self.view.frame = CGRectMake(0, -90, WIDTH, HEIGHT);
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
    return YES;
}
//textView结束编辑的时候调用
- (BOOL)textViewShouldEndEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textView = nil;
    self.toolBar = nil;
    self.picker = nil;
}

-(void)dealloc
{
    //注销通知
    [[NSNotificationCenter defaultCenter ] removeObserver:self 
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil ];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil];
    [_picker release];
    [_textView release];
    [toolBar release];
    [shareString release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)ButtonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            [self shareTencentPicClick:nil];
           
            break;
        }
       case 2:
        {
            [self enterWeibo];
            break;
        }
    }
}
@end
