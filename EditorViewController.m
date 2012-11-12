
#import "EditorViewController.h"
#import "OptionalPlaceViewController.h"
#import "StorePlaceViewController.h"
#import "NowPlaceViewController.h"
#import "BuildingViewController.h"
#import "WeiBoViewController.h"
#import "SearchMassage.h"
#import "PlaceMessage.h"
#import "PlaceMark.h"

@implementation EditorViewController

@synthesize saveButton;
@synthesize tabelView;
@synthesize nameText;//添加公司的名字
@synthesize addTextField;//显示附加信息
@synthesize messageLable;//显示参照物信息
@synthesize companyTextField;//显示公司的名字
@synthesize textView;//显示当前的位置信息和地图
@synthesize toolBar;//透明的条
@synthesize placeName;//当前位置的名字
@synthesize placeLat;//当前位置的纬度
@synthesize placeLon;//当前位置的经度
@synthesize placeMess;//当前位置的详细信息
@synthesize buildName;//建筑物的名称
@synthesize baoCunName;//保存名字
@synthesize imageData;//存储图片
@synthesize addString;//添加的数据
@synthesize messageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark 
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    BaoCun = NO;
    self.tabelView.frame = CGRectMake(18, 69, 285, 312);
    [tabelView reloadData];
    
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

#pragma mark - 
#pragma mark keyboard Methods
//键盘弹出时的方法
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    toolBar.frame = CGRectMake(0, 460-kbSize.height-toolBarHeight, WIDTH, toolBarHeight);
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
    [self.companyTextField resignFirstResponder];
    [self.addTextField resignFirstResponder];
    self.tabelView.frame = CGRectMake(18, 69, 285, 270);
    toolBar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark UITableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//设置行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    if (indexPath.row == 1) {
         return 150;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellItem = @"cellItem";
    static NSString *cellName = @"cellName";
    static NSString *cellBuilding = @"cellBuilding";
    static NSString *cellAdd = @"celladd";
    UIImageView * lineImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 286, 1)] autorelease];
    lineImageView.image = [UIImage imageNamed:@"虚线.png"];
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 290, 30)];
            companyTextField.backgroundColor = [UIColor clearColor];
            companyTextField.font = [UIFont systemFontOfSize:15];
            companyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            companyTextField.delegate = self;
            companyTextField.returnKeyType = UIReturnKeyDone;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
        companyTextField.text = self.baoCunName;
        companyTextField.textColor = [UIColor grayColor];
        [cell.contentView addSubview:companyTextField];
        return cell;
        }
    if(indexPath.row == 1) {
        //设置当前信息的cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellItem];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellItem] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView * aiew in [cell.contentView subviews]) {
            [aiew removeFromSuperview];
        } 
        lineImageView.image = [UIImage imageNamed:@"虚线.png"];
        [cell.contentView addSubview:lineImageView];
        [self performSelector:@selector(drawMapViewandTextView)];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 108, 16, 25)];
        image.image = [UIImage imageNamed:@"位置.png"];
        [cell.contentView addSubview: mapView];
        [cell.contentView addSubview:textView];
        [cell.contentView addSubview:image];
        [image release];
        return cell;
    }
    else if (indexPath.row == 2) {
        //设置参考物的cell
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 14, 16)];
        cell = [tableView dequeueReusableCellWithIdentifier:cellBuilding];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBuilding] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            image.image = [UIImage imageNamed:@"店名.png"];
            [self performSelector:@selector(customNearbyBuildingMessage)];
        }
        for (UIView * aiew in [cell.contentView subviews]) {
            [aiew removeFromSuperview];
        }
        [cell.contentView addSubview:lineImageView];
        [cell.contentView addSubview:messageLable];
        [cell.contentView addSubview:image];
        [image release];
        return cell;
    }
    else {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 14, 16)];
        //设置附加信息的cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellAdd];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAdd] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            image.image = [UIImage imageNamed:@"地址.png"];
            [self performSelector:@selector(addTheOtherMessage)];
        }
        [cell.contentView addSubview:lineImageView];
        [cell.contentView addSubview:addTextField];
        [cell.contentView addSubview:image];
        [image release];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (BaoCun == YES) {
        if (indexPath.row == 2) {
            BuildingViewController *build = [[BuildingViewController alloc] initWithNibName:@"BuildingViewController" bundle:nil];
            build.delegate = self;//将代理设置为自己
            build.buildingLon = placeLon;
            build.buildingLat = placeLat;
            [self.navigationController pushViewController:build animated:YES];
        }
   }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}
//绘制MapView和TextView
-(void)drawMapViewandTextView
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(30 , 95, 300, 50)];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 5, 268, 90)];
    view = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 100)];
    [view addSubview:mapView];
    
    CLLocationCoordinate2D mark2D;
    mark2D.latitude = placeLat;
    mark2D.longitude = placeLon;
    //给地图视图添加边框
    mapView.layer.masksToBounds = YES;
    mapView.layer.cornerRadius = 10.0;
    mapView.layer.borderColor = [UIColor purpleColor].CGColor;
    mapView.layer.borderWidth = 1;
    
    PlaceMark * mark = [[PlaceMark alloc] initWithCoordinates:mark2D];
    [mapView addAnnotation:mark];
    [mark release];
    
    MKCoordinateSpan theSpan; 
    ////地图的范围 越小越精确 
    theSpan.latitudeDelta = 0.01f; 
    theSpan.longitudeDelta = 0.01f; 
    
    MKCoordinateRegion theRegion; 
    CLLocationCoordinate2D cr = mark.coordinate;
    theRegion.center = cr;  
    theRegion.span = theSpan; 
    [mapView setRegion:theRegion animated:NO];
    if (self.baoCunName) {
        self.textView.textColor = [UIColor grayColor];
        self.textView.text = [NSString stringWithFormat:@"%@\n%@",placeName,placeMess];
    }
    else {
        self.textView.text = [NSString stringWithFormat:@"%@\n%@",placeName,placeMess];
    }
    [self.textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    self.textView.delegate = self;
    self.textView.bounces = NO;
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    [mapView release];
}
//添加参考物的信息
-(void)customNearbyBuildingMessage
{
    messageLable = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 223, 30)];
    messageLable.backgroundColor = [UIColor clearColor];
    messageLable.font = [UIFont systemFontOfSize:13.0f];
    if (self.baoCunName) {
        self.messageLable.textColor = [UIColor grayColor];
        self.messageLable.text = self.buildName;
    }
    else
    {   
        self.messageLable.text = @"添加参照物";//参考的位置
    }
    self.messageLable.numberOfLines = 2;
}
//添加附加的信息
-(void)addTheOtherMessage
{
    addTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 5, 280, 30)];
    addTextField.backgroundColor = [UIColor clearColor];
    addTextField.font = [UIFont systemFontOfSize:14.0];
    addTextField.text = self.addString;
    addTextField.textColor = [UIColor grayColor];
    addTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addTextField.delegate = self;
    addTextField.returnKeyType = UIReturnKeyDone;
}

#pragma mark BuildingViewControllerDelegate Methods
-(void)passBuildingMessage:(NSString *)buildingMessage
{
    messageLable.text = buildingMessage;
}

#pragma mark - 
#pragma mark textFieldDelegate 
//附加信息的填写
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (BaoCun == NO) {
        [self.addTextField resignFirstResponder];
        [companyTextField resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    else {
        if (self.addTextField == textField) {
            if ([self.addTextField.text isEqualToString:@"添加附加信息"]) {
                self.addTextField.clearsOnBeginEditing = YES;
            }
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:0.30f];
            self.tabelView.frame = CGRectMake(18, -69, 285, 270);
            [UIView commitAnimations];
        }
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.addTextField == textField) {
        self.tabelView.frame = CGRectMake(18, 69, 285, 270);
        self.toolBar.frame = CGRectMake(0, HEIGHT, WIDTH,toolBarHeight);
        
    }
    [companyTextField resignFirstResponder];
    [addTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.addTextField == textField) {
        self.addString = self.addTextField.text;
    }
}

#pragma mark - 
#pragma mark textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    if (BaoCun == NO) {
        [textview resignFirstResponder];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"不在编辑状态" message:@"请选择编辑按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return NO;
    }
    else
    {
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:0.30f];
        self.tabelView.frame = CGRectMake(18, -28, 285, 270);
        [UIView commitAnimations];
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textview
{
    [textview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    return YES;
}

#pragma mark - 
#pragma mark SaveDataSoure Methods
//截取图片
-(UIImage *)captureView:(UIView *)imageView
{
    CGRect rect = imageView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect1 = CGRectMake(90, 0, 85, 85);//创建矩形
    UIImage *picImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect1)];
    return picImage;
}

- (IBAction)buttonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            if (BaoCun == YES) {
                int count = 0;
                NSMutableArray *array = [PlaceMessage findAllMessage];
                if (count < array.count) {
                    count = array.count;
                } 
                //数据的修改
                UIImage *image = [self captureView:mapView];
                [PlaceMessage upDatePlaceName:placeName andPlaceLat:placeLat andPlaceLon:placeLon andPlaceMess:placeMess andCeKaoName:self.messageLable.text andBaoCunName:self.companyTextField.text andImageData:image andAddMessage:self.addTextField.text fromID:count];
                self.messageLable.textColor = [UIColor grayColor];
                self.addTextField.textColor = [UIColor grayColor];
                self.textView.textColor = [UIColor grayColor];
                self.companyTextField.textColor = [UIColor grayColor];
                BaoCun = NO;
                [self.saveButton setImage:[UIImage imageNamed:@"编辑-一般.png"] forState:UIControlStateNormal];
            }
            else {
                self.messageLable.textColor = [UIColor blackColor];
                self.addTextField.textColor = [UIColor blackColor];
                self.textView.textColor = [UIColor blackColor];
                self.companyTextField.textColor = [UIColor blackColor];
                BaoCun = YES;
                [self.saveButton setImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
            }
            break;
        }   
        case 1:
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"分享信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到短信" otherButtonTitles:@"分享到微博", nil];
            [action showFromToolbar:toolBar];
            [action release];
            break;
        }
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 3:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 4:
        {
            NowPlaceViewController *nowPlace = [[NowPlaceViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:nowPlace animated:YES];
            [nowPlace release];
            break;
        }
    }
}

#pragma mark - 
#pragma mark UIActionSheet Delegate
//buttonIndex 为0代表发送到短信， 为1代表发送到微博
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self sendMessageToOtherPerson];
    }
    else if (buttonIndex == 1) {
        WeiBoViewController *weibo = [[WeiBoViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:weibo animated:YES];
        weibo.shareString = [NSString stringWithFormat:@"我在%@。\n旁边有%@\n详细信息可以参考参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.messageLable.text,placeLat,placeLon];
        [weibo release];
    }
}

#pragma mark - 
#pragma mark sendMessage
-(void)sendMessageToOtherPerson
{
//    NSString *postString =[NSString stringWithFormat:@"act=position&dev=ios&ver=1.1&p_lat=%f&p_long=%f&p_add=%@&net=wifi&op=00&r_add=%@",placeLat,placeLon,placeMess,self.buildName];  
//    NSURL *url = [NSURL URLWithString:@"http://ibokan.gicp.net/ibokan/map/map.php"];    
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];       
//    [req setHTTPMethod:@"POST"]; 
//    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//    if (messageClass != nil) {
//        [self displaySMSComposerSheet];
//    }
//    else {
        UIAlertView *alteView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备没有短信功能，您不能发送信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alteView show];
        [alteView release];
//    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = self;
    if ([self.messageLable.text isEqualToString:@"添加参照物"]) {
        if ([addTextField.text isEqualToString:@"添加附加信息"]) {
            message.body = [NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,placeLat,placeLon];
        }else if ([addTextField.text isEqualToString:@""]) {
            message.body = [NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,placeLat,placeLon];
        }
        else {
            message.body = [NSString stringWithFormat:@"我在%@。\n%@参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.addString,placeLat,placeLon];
        }
    }else if ([self.messageLable.text isEqualToString:@""]) {
        if ([addTextField.text isEqualToString:@"添加附加信息"]) {
            message.body = [NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,placeLat,placeLon];
        }else if ([addTextField.text isEqualToString:@""]) {
            message.body = [NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,placeLat,placeLon];
        }
        else {
            message.body = [NSString stringWithFormat:@"我在%@。\n%@参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.addString,placeLat,placeLon];
        }
    }
    else
    {
        if ([addTextField.text isEqualToString:@"添加附加信息"]) {
            message.body = [NSString stringWithFormat:@"我在%@。\n%@参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.addString,placeLat,placeLon];
        }else if([addTextField.text isEqualToString:@""])
        {
            message.body = [NSString stringWithFormat:@"我在%@。\n%@参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.addString,placeLat,placeLon];
        }
        else{
            message.body = [NSString stringWithFormat:@"我在%@。\n%@参考地图: http://maps.google.com/maps?q=loc:%f,%f",self.textView.text,self.addString,placeLat,placeLon];
        }
        
    }  
    [self presentViewController:message animated:YES completion:nil];
    [message release];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)   
    {   
        case MessageComposeResultCancelled:   
            NSLog(@"Result: SMS sending canceled");   
            break;   
        case MessageComposeResultSent:   
            break;   
        case MessageComposeResultFailed:   
        {
            NSLog(@"Result: SMS sent");
            UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:
                                   @"短信发送失败!" delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [act showFromTabBar:self.tabBarController.tabBar];
            [act release];
            break;   
        }
        default:   
            NSLog(@"Result: SMS not sent");   
            break;   
    } 
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.nameText.inputAccessoryView=NO;
    
    
    if (BaoCun == YES) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存本信息！" delegate:self cancelButtonTitle:@"保存" otherButtonTitles:@"不保存", nil];
        [alertView setTag:101];
        [alertView show];
        [alertView release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    self.addTextField = nil;
    self.messageLable = nil;
    self.textView = nil;
    self.toolBar = nil;
    self.placeMess = nil;
    self.placeName = nil;
    self.buildName = nil;
    self.baoCunName = nil;
    self.imageData = nil;
    self.addString = nil;
    [self setTabelView:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    //注销通知
    [[NSNotificationCenter defaultCenter ] removeObserver:self 
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil ];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil];
    [nameText release];
    [companyTextField release];
    [fujiaField release];
    [messageLable release];
    [textView release];
    [toolBar release];
    [placeMess release];
    [buildName release];
    [baoCunName release];
    [imageData release];
    [addString release];
    [alterView release];
    [tabelView release];
    [super dealloc];
}
@end
