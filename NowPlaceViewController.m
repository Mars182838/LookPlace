
#import "NowPlaceViewController.h"
#import "Const.h"
#import "Place.h"
#import "PlaceMark.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "PlaceMessageViewController.h"
#define WiDTH self.view.bounds.size.width
#define NumberButton 10

@interface NowPlaceViewController ()

@end

@implementation NowPlaceViewController
@synthesize myMapView;//地图
@synthesize activityView;//加载指示器
@synthesize imageButton;
@synthesize nearTabelView;//显示当前位置的信息

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - 
#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    backTabelView = YES;//用于设置左边按钮时是否弹出表视图
    self.myMapView.delegate = self;//设置mapView的代理为自己
    [self performSelector:@selector(optionalPlace)];//程序加载时的用户当前位置
    //长按手势，获取经纬度
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.0f;
    longPress.allowableMovement = 10.0f;
    [self.myMapView addGestureRecognizer:longPress];
    [longPress release];
    
    //自定义一个UIview用于实现tabelView
    tView = [[UIView alloc] initWithFrame:CGRectMake(0, 420, WiDTH, 240)];
    tView.backgroundColor = [UIColor clearColor];
    //加载指示器
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 50, 20, 20)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //初始化neaTabelView
    nearTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, WiDTH, 160) style:UITableViewStylePlain];
    nearTabelView.delegate = self;
    nearTabelView.dataSource = self;
    //tableView上面的按钮
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    [scrollView setContentSize:CGSizeMake(50*NumberButton,30)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏背景.png"]];
    scrollView.showsHorizontalScrollIndicator = NO;
    for (int count= 0; count < NumberButton; count++) {
        imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(count*50, 0, 50, 30);
        imageButton.tag = count + 10;
        [imageButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"b%d.jpg",2*count + 1]] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
         [scrollView addSubview:imageButton];
    }   
    [tView addSubview:scrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(300, 0, 20, 30);
    [button setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeTabelView) forControlEvents:UIControlEventTouchUpInside];
    [tView addSubview:button];
    [self.nearTabelView addSubview:activityView];//添加Activity的表视图
    [tView addSubview:self.nearTabelView];//添加到UIView上面
    [self.view addSubview:tView];//自定义的UIview添加到主视图上
    
    search = [[SearchMassage alloc] init];//初始化封装数据的类
}

//当前位置信息
-(void)optionalPlace
{
    place = [[Place alloc] initWithCoordinates:ShareApp.location];
    [self.myMapView setRegion:ShareApp.theRegion animated:YES];
    
    location = [[CLLocation alloc] initWithLatitude:ShareApp.location.latitude longitude:ShareApp.location.longitude];
    //反向解析当前位置的数据
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *Mark = [placemark objectAtIndex:0];
         place.title = @"没有当前位置的详细信息";
         place.subTitle = @"详细信息请点击‘附近’查看";
         place.title = [NSString stringWithFormat:@"%@%@%@",Mark.subLocality,Mark.thoroughfare,Mark.subThoroughfare];//获取title信息
         place.subTitle = [NSString stringWithFormat:@"%@",Mark.name];//获取subtitle的信息
         [self.myMapView selectAnnotation:place animated:YES];
     }]; 
    [self.myMapView addAnnotation:place];
}

#pragma mark - 
#pragma mark Opration Methods
//长按时从新插一个大头针
-(void)longPress:(UIGestureRecognizer *)sender
{
    backTabelView = YES;
    if (sender.state == UIGestureRecognizerStateBegan) {
        //坐标的变换
        CGPoint touchPoint = [sender locationInView:self.myMapView];
        CLLocationCoordinate2D touchCoordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];//将触摸得点转换为经纬度。
        //反向解析长按时的大头针的信息
        location = [[CLLocation alloc] initWithLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
        NSLog(@"%f,%f",touchCoordinate.latitude,touchCoordinate.longitude);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error){
            
            CLPlacemark *place1 = [placemark objectAtIndex:0];
            if ([place1.thoroughfare length] == 0) {
                placeMark.title = [NSString stringWithFormat:@"%@",place1.subLocality];
            }
            else if (place1.subThoroughfare == 0) {
                placeMark.title = [NSString stringWithFormat:@"%@%@",place1.subLocality,place1.thoroughfare];;
            }
            else {
                placeMark.title = [NSString stringWithFormat:@"%@%@%@",place1.subLocality,place1.thoroughfare,place1.subThoroughfare];
            }
            placeMark.subTitle = [NSString stringWithFormat:@"%@",place1.name];
            [self.myMapView selectAnnotation:placeMark animated:YES];
            [geocoder release];
        }];
        
        //插针,如果地图上已经有一个大头针后，把前面的那个大头针删了，在从新的插上一个大头针
        if ([myMapView.annotations containsObject:placeMark]) {
            [myMapView removeAnnotation:placeMark];
        }
        placeMark = [[PlaceMark alloc] initWithCoordinates:location.coordinate];
        [self.myMapView addAnnotation:placeMark];
    }
}

#pragma mark - 
#pragma mark MapViewDelegate Methods
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *defauntPinID = @"annotationID";
    pinView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:defauntPinID];
    if (pinView == nil) {
        MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defauntPinID] autorelease];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.canShowCallout = YES;
        customPinView.animatesDrop = YES;
        
        //右按钮 推出下一个页面
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 40, 30);
        rightBtn.tag = 1;
        UIImage *image = [UIImage imageNamed:@"Arrow-Icon.png"];
        [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightBtn;
        
        //左按钮 显示周边信息
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 53, 30);
        UIImage *imageView =[UIImage imageNamed:@"附近.png"];
        [leftBtn setBackgroundImage:imageView forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(removeTabelView) forControlEvents:UIControlEventTouchUpInside];
        customPinView.leftCalloutAccessoryView = leftBtn;
        return customPinView;
    }    
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

#pragma mark - 
#pragma mark JSONSerialization Methods
//解析JSON数据
-(void)praserNearybyMessageByGoogle:(id *)sender
{
   // https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c
    NSString *jsonData = nil;
    jsonData = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"food"];//当前位置的数据URL
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonData]];//转换成二进制的数据流
    id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];//解析附近数据
    search.nearbyArray = [jsonPraser objectForKey:@"results"];//获取所有的附近信息存放到数组里面
    //去掉数组的第一个和最后一个数
    dispatch_queue_t mainQueue = dispatch_get_main_queue();//采用异步的主线程进行数据更新      
    dispatch_async(mainQueue, ^{
        [nearTabelView reloadData];//刷新数据
        [activityView stopAnimating];
    });
    dispatch_release(mainQueue);//一定要释放
}

//选择分类的数据并解析数据
-(void)chooseButton:(UIButton *)sender
{
    NSString *jsonString = nil; 
    switch (sender.tag) {
        case 10:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"food"];
            break;
        }
        case 11:
        {           
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"lodging"];
            break;
        }
        case 12:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"clothing_store"];
            break;
        }
        case 13:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"bus_station"];
            break;
        }
        case 14:
        {
             jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"park"];
           
            break;
        }
        case 15:
        {
             jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"gym"];
            break;
        }
        case 16:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"hospital"];
            break;
        }
        case 17:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"cafe"];
            break;
        }
        case 18:
        {
             NSLog(@"9");
             jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"movie_theater"];
            break;
        }
        case 19:
        {
           jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"bank"];
            break;
        }
    }
    [activityView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonString]];
    id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    search.nearbyArray = [jsonPraser objectForKey:@"results"];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async
    (mainQueue, ^{
        [nearTabelView reloadData];//UI界面只能用主线程刷新数据
        [activityView stopAnimating];
    });
    dispatch_release(mainQueue);//释放队列
    });
}
   
-(IBAction)buttonPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            //取消返回到主界面
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }    
        case 1:
        {
            //右按钮，进入下个页面
            PlaceMessageViewController *placeMessage = [[PlaceMessageViewController alloc] initWithNibName:@"PlaceMessageViewController" bundle:nil];
            if ([[self.myMapView.selectedAnnotations objectAtIndex:0] isMemberOfClass:[PlaceMark class]]) {
                //如果是PlaceMark类时，采用属性传值的方式传值到PlaceMessageViewController类
                placeMessage.placeLat = location.coordinate.latitude;
                placeMessage.placeLon = location.coordinate.longitude;
                placeMessage.placeName = placeMark.title;
                placeMessage.placeMess = placeMark.subTitle;
            }
            else {
                //否则采用属性传值的方式，将place类传给PlaceMessageViewController类
                placeMessage.placeLat = location.coordinate.latitude;
                placeMessage.placeLon = location.coordinate.longitude;
                placeMessage.placeName = place.title;
                placeMessage.placeMess = place.subTitle;
            }
            [self.navigationController pushViewController:placeMessage animated:YES];
            [placeMessage release];
            break;
        }
        case 2:
        {
            //刷新当前位置
            if ([myMapView.annotations containsObject:place]) {
                [myMapView removeAnnotation:place];
            }
            [self performSelector:@selector(optionalPlace)];
            break;
        }
    }
}

//弹出与回收tabelView
-(void)removeTabelView
{
    //左按钮实现tabelView的弹出与收回
    if (backTabelView == YES) {
        [activityView startAnimating];//开启指示器
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        tView.frame = CGRectMake(0, 250, WiDTH, 160);//tview上移
        self.myMapView.frame = CGRectMake(0, 0, WiDTH, 367);//调整mapView，将其上移44个像素
        [UIView commitAnimations];
        backTabelView = NO;
        //GCD异步解析数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelector:@selector(praserNearybyMessageByGoogle:)];
        });
    }
    else {
        //收回tabelView;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        tView.frame = CGRectMake(0, 420, WiDTH, 160);//tview往下移
        self.myMapView.frame = CGRectMake(0, 44, WiDTH, 367);//mapView往下移44个像素
        [UIView commitAnimations];
        backTabelView = YES;
        [activityView stopAnimating];//返回时关闭指示器
    }
}

#pragma mark - 
#pragma mark TabelViewDelegate Methods
//返回tableview的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [search.nearbyArray count];
}

//设置cell的样式以及cell的数据显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIndentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-copy-3"]];
        cell.accessoryView = accessoryView;
        [accessoryView release];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row %2 == 0) {
        cell.contentView.backgroundColor = Text_color;
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    return cell;
}
//选中cell时采用属性传值的方式，将数据传给 PlaceMessageViewController类
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceMessageViewController *placeMessage = [[PlaceMessageViewController alloc] initWithNibName:@"PlaceMessageViewController" bundle:nil];
    [self.navigationController pushViewController:placeMessage animated:YES];
    
    //将数据封装到SearchMessage类
    search.placeName = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    search.placeMess = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    search.placeLat =[[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lat"] floatValue];
    search.placeLon = [[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"] floatValue];
    //传参数到PlaceMessage类中
    placeMessage.placeName = search.placeName;
    placeMessage.placeMess = search.placeMess;
    placeMessage.placeLat = search.placeLat;
    placeMessage.placeLon = search.placeLon;
    [placeMessage release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.nearTabelView = nil;
    self.activityView = nil;
    self.imageButton = nil;
    self.myMapView = nil;
}

-(void)dealloc
{
    [myMapView release];
    [nearTabelView release];
    [activityView release];
    [imageButton release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
