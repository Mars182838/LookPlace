
#import "WeiBoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PlaceMessageViewController.h"

@interface WeiBoViewController ()

@end

@implementation WeiBoViewController
@synthesize textView = _textView;
@synthesize pictureButton;
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
    isFirst = YES;
    tencentOAuthManager = [[OAuthManager alloc] initWithOAuthManager:TENCENT_WEIBO];
    //点击UIimageView会自动调出相册
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0f, 240.0f, 130.0f, 100.0f)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    myImageView = imageView; 
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
    if (picker.allowsEditing == YES) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    myImageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
}

#pragma -
#pragma mark UIAtionSheet Delegate
//buttonIndex 为0表示照相 1表示从相册中选择图片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
    picker.delegate = self;  
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
                {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
                    [self presentModalViewController:picker animated:YES];  
                    [picker release];  
            }
            else {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持照相功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alter show];
                [alter release];
            }
            break;
        }   
        case 1:
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];  
            [picker release];  
            break;
        }
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
            if (isFirst == YES) {
                 [self enterWeibo];
                isFirst = NO;
            }
            else {
                [self shareTencentPicClick:nil];
            }
            break;
        }
        case 2:
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            action.delegate = self;
            [action showFromToolbar:toolBar];
            [action release];
        }
    }
}


- (void)viewDidUnload
{
    [self setPictureButton:nil];
    [super viewDidUnload];
    self.textView = nil;
    self.toolBar = nil;
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
    [_textView release];
    [toolBar release];
    [shareString release];
    [pictureButton release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
