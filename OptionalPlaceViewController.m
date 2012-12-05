
#import "OptionalPlaceViewController.h"
#import "PlaceMessageViewController.h"
#import "customTabelViewCell.h"
#import "RootViewController.h"
#import "SearchMassage.h"
#import "AppDelegate.h"
#import "PlaceMark.h"
#import "Const.h"
#import "Place.h"
#define NumberButton 10

@interface OptionalPlaceViewController ()

@end

@implementation OptionalPlaceViewController
@synthesize myMapView;
@synthesize myTableView;//显示当前位置的信息
@synthesize nearTabelView;//显示附近位置的信息
@synthesize searchBar;//自己选择位置
@synthesize activityView;//指示器
@synthesize toolBar;
@synthesize search;//
@synthesize imageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myMapView selectAnnotation:place animated:YES];
}

#pragma mark - 
#pragma mark lifeCycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    backTabelView = YES;//用于设置左边按钮时是否弹出表视图
    self.myMapView.delegate = self;//设置mapView的代理为自己
    search = [[SearchMassage alloc] init];
    [self performSelector:@selector(optionalPlace)];
    
    //长按手势，获取经纬度
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.0f;
    longPress.allowableMovement = 10.0f;
    [self.myMapView addGestureRecognizer:longPress];
   [longPress release];
    
    //自定义一个UIview用于实现tabelView
    tView = [[UIView alloc] initWithFrame:CGRectMake(0, 410, WIDTH, 160)];
    tView.backgroundColor = [UIColor clearColor];
    
    activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 40, 20, 20)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //存储附近信息的数组
    nearTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 160) style:UITableViewStylePlain];
    nearTabelView.delegate = self;
    nearTabelView.dataSource = self;
    
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

    //上移和收回UItableView的button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(300, 0, 20, 30);
    [button setImage:[UIImage imageNamed:@"back.jpg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeTabelView) forControlEvents:UIControlEventTouchUpInside];
    [tView addSubview:button];
    [self.nearTabelView addSubview:activityView];//添加Activity的表视图
    [tView addSubview:self.nearTabelView];
    [self.view addSubview:tView];

    searchBar.delegate = self;
    searchBar.keyboardType = UIKeyboardTypeURL;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //放置隐藏键盘的按钮
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,HEIGHT,WIDTH,toolBarHeight)];
    self.toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem * hiddenButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jianpan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(HiddenKeyBoard)];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolBar.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
    [self.view addSubview:self.toolBar];
    [hiddenButtonItem release];
    [spaceButtonItem release];
    //监控键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //监控键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 
#pragma mark LongPress and NowPlace Methods
-(void)longPress:(UIGestureRecognizer *)sender
{
    backTabelView = NO;
    [self removeTabelView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //坐标的变换
        CGPoint touchPoint = [sender locationInView:self.myMapView];
        CLLocationCoordinate2D touchCoordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];//将触摸得点转换为经纬度。
        //解析长按时的地点数据
        location = [[CLLocation alloc] initWithLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error){
            CLPlacemark *place1 = [placemark objectAtIndex:0];
            if ([place1.thoroughfare length] == 0) {
                placeMark.title = [NSString stringWithFormat:@"%@",place1.subLocality];//没有街道
            }
            else if ([place1.subThoroughfare length]== 0) {
                placeMark.title = [NSString stringWithFormat:@"%@%@",place1.subLocality,place1.thoroughfare];//没有门牌号
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

//当前位置信息
-(void)optionalPlace
{
    place = [[Place alloc] initWithCoordinates:ShareApp.location];
    place.title = @"没有当前位置的详细信息";
    place.subTitle = @"详细信息请点击‘附近’查看";
    [self.myMapView addAnnotation:place];
    [self.myMapView setRegion:ShareApp.theRegion animated:YES];
    
    location = [[CLLocation alloc] initWithLatitude:ShareApp.location.latitude longitude:ShareApp.location.longitude];
    //反向解析当前位置的数据
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *Mark = [placemark objectAtIndex:0];
         place.title = [NSString stringWithFormat:@"%@%@%@",Mark.subLocality,Mark.thoroughfare,Mark.subThoroughfare];//获取title信息
         place.subTitle = [NSString stringWithFormat:@"%@",Mark.name];//获取subtitle的信息
         [self.myMapView selectAnnotation:place animated:YES];
     }]; 
}

#pragma mark - 
#pragma mark MapViewDelegate Methods
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
     //右按钮 推出下一个页面
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    rightBtn.tag = 1;
    UIImage *image = [UIImage imageNamed:@"Arrow-Icon.png"];
    [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    [rightBtn addTarget:self 
                 action:@selector(buttonPress:) 
       forControlEvents:UIControlEventTouchUpInside];
    
     //左按钮 显示周边信息
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 53, 30);
    UIImage *imageView =[UIImage imageNamed:@"附近.png"];
    [leftBtn setBackgroundImage:imageView forState:UIControlStateNormal];
    [leftBtn addTarget:self 
                action:@selector(removeTabelView) 
      forControlEvents:UIControlEventTouchUpInside];  
    if ([annotation isMemberOfClass:[Place class]]) {
        static NSString *palceIndentifer = @"palceIndentifer";
        MKAnnotationView *placeView = [[[MKAnnotationView alloc] initWithAnnotation:place reuseIdentifier:palceIndentifer] autorelease];
        UIImage *imageplace = [UIImage imageNamed:@"蓝色圆点151.png"];
        placeView.image = imageplace;
        placeView.canShowCallout = YES;
        placeView.annotation = annotation;
        placeView.rightCalloutAccessoryView = rightBtn;
        placeView.leftCalloutAccessoryView = leftBtn;
        return placeView;  
   }
    else{
        static NSString *defauntPinID = @"annotationID";
        MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defauntPinID] autorelease];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.canShowCallout = YES;
        customPinView.animatesDrop = YES;
        customPinView.rightCalloutAccessoryView = rightBtn;
        customPinView.leftCalloutAccessoryView = leftBtn;
        return customPinView;
    }
   return nil;
}

#pragma mark - 
#pragma mark JSONParser
//解析Google的API，获取当前位置的附近信息
-(void)praserNearybyGOOGLE
{
    // https://maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=1000&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c
    NSString *jsonData = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c",location.coordinate.latitude,location.coordinate.longitude];    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonData]];
    id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
    search.nearbyArray = [jsonPraser objectForKey:@"results"];
    int count = search.nearbyArray.count;
    search.nearbyArray = [search.nearbyArray subarrayWithRange:NSMakeRange(1, count - 2)];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [nearTabelView reloadData];//UI界面只能用主线程刷新数据
        [activityView stopAnimating];
    });
    dispatch_release(mainQueue);//释放队列
}

//通过请求Google的API，分类别请求数据
-(void)chooseButton:(UIButton *)sender
{
    NSString *jsonString = nil; 
    switch (sender.tag) {
        case 10:
        {
            [self.imageButton setImage:[UIImage imageNamed:@"b13.jpg"] forState:UIControlStateNormal];
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
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"movie_theater"];
            break;
        }
        case 19:
        {
            jsonString = [NSString stringWithFormat:SEARCH_GOOGLE,location.coordinate.latitude,location.coordinate.longitude,@"bank"];
            
        }
    }
    [activityView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonString]];
        id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
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


#pragma mark - 
#pragma mark TabelViewDelegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == nearTabelView) {
        return  search.nearbyArray.count;
    }
    else {
        return search.searchArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIndentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (tableView == nearTabelView) {
        cell.textLabel.text = [[search.nearbyArray  objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else{
        cell.textLabel.text = [[search.searchArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [[search.searchArray objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//nearTableView代表附近位置的信息显示，myTableView是指的自选位置的信息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == nearTabelView) {
        backTabelView = NO;
        [self removeTabelView];
        lat = [[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        lon = [[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        [self selectPointInMapView];
    }
    else {
        self.myTableView.frame = CGRectMake(0, -HEIGHT, WIDTH,HEIGHT);
        lat = [[[[[search.searchArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        lon = [[[[[search.searchArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        [self selectPointInMapView];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
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

//选中cell时往地图上扎一个大头针
-(void)selectPointInMapView
{
    location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error){
        CLPlacemark *place1 = [placemark objectAtIndex:0];
        if ([place1.thoroughfare length] == 0) {
            placeMark.title = [NSString stringWithFormat:@"%@",place1.subLocality];//没有街道
        }
        else if (place1.subThoroughfare == 0) {
            placeMark.title = [NSString stringWithFormat:@"%@%@",place1.subLocality,place1.thoroughfare];//没有门牌号
        }
        else {
            placeMark.title = [NSString stringWithFormat:@"%@%@%@",place1.subLocality,place1.thoroughfare,place1.subThoroughfare];
        }
        placeMark.subTitle = [NSString stringWithFormat:@"%@",place1.name];
        [self.myMapView selectAnnotation:placeMark animated:YES];
        [geocoder release];
    }];
    
    if ([self.myMapView.annotations containsObject:placeMark]) {
        [self.myMapView removeAnnotation:placeMark];
    }

    MKCoordinateSpan theSpan; 
    MKCoordinateRegion theRegion;
    theSpan.latitudeDelta = 0.01f; 
    theSpan.longitudeDelta = 0.01f; 
    theRegion.center = location.coordinate; 
    theRegion.span = theSpan;
    [self.myMapView setRegion:theRegion];
     placeMark = [[PlaceMark alloc] initWithCoordinates:location.coordinate];
    [self.myMapView addAnnotation:placeMark];
}

#pragma mark - 
#pragma mark buttonPress Methods
- (IBAction)buttonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:{
            //返回到主界面
            [self dismissViewControllerAnimated:YES completion:^(){  }];
            break;
        }
        case 1:
        {
            //右按钮，进入下个页面
            PlaceMessageViewController *placeMessage = [[PlaceMessageViewController alloc] initWithNibName:@"PlaceMessageViewController" bundle:nil];
            if ([[self.myMapView.selectedAnnotations objectAtIndex:0] isMemberOfClass:[PlaceMark class]]) {
                placeMessage.placeLat = location.coordinate.latitude;
                placeMessage.placeLon = location.coordinate.longitude;
                placeMessage.placeName = placeMark.title;
                placeMessage.placeMess = placeMark.subTitle;
            }
            else {
                placeMessage.placeLat = location.coordinate.latitude;
                placeMessage.placeLon = location.coordinate.longitude;
                placeMessage.placeName = place.title;
                placeMessage.placeMess = place.subTitle;
            }
            [self.navigationController pushViewController:placeMessage animated:YES];
            [placeMessage release];
            break;
        }
    }
}

//弹出与回收tabelView
-(void)removeTabelView
{
    //左按钮实现tabelView的弹出与收回
    if (backTabelView == YES) {
        [activityView startAnimating];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        tView.frame = CGRectMake(0, 250, WIDTH, 160);
        self.myMapView.frame = CGRectMake(0, 0, WIDTH, 367);//调整mapView，将其上移44个像素
        [UIView commitAnimations];
        backTabelView = NO;
        //GCD异步解析数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelector:@selector(praserNearybyGOOGLE)];
        });
    }
    else {
        //收回tabelView;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        tView.frame = CGRectMake(0, HEIGHT, WIDTH, 160);
        self.myMapView.frame = CGRectMake(0, toolBarHeight, WIDTH, 367);
        [UIView commitAnimations];
        backTabelView = YES;
        [activityView stopAnimating];
    }
}

#pragma mark - 
#pragma mark SearchBar Delegate Methods
//点击搜索时
-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

//searchBar 开始输入搜索的关键字
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)search
{
    backTabelView = NO;
    [self removeTabelView];
    [searchBar resignFirstResponder];
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchbar 
{
    //https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=50000&name=%@&sensor=false&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c
    [searchBar resignFirstResponder];
     self.myTableView.frame = CGRectMake(0, 46,WIDTH, HEIGHT);
    //异步下载数据，为了提高用户体验
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(130, 180, 30, 30);
    [self.myTableView addSubview:activity];
    [activity startAnimating];
    //解析JSON数据
    NSString *DataUrlString = [[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=150000&hl=zh-CN&name=%@&sensor=false&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c",location.coordinate.latitude,location.coordinate.longitude,searchBar.text];
    NSString *jsonData = [DataUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//url不能含有中文
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonData]];
    id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [DataUrlString release];
    //将获取到的数据封装，是为了数据和视图分离
    search.searchArray = [jsonPraser objectForKey:@"results"];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [myTableView reloadData];//UI界面只能用主线程刷新数据
        [activity stopAnimating];
    });
    dispatch_release(mainQueue);//释放队列
    });
}

#pragma mark - 
#pragma mark KeyBoard Show and Hide Methods
//隐藏键盘的按钮的方法
-(void)HiddenKeyBoard
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [searchBar resignFirstResponder];
    self.toolBar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}
//监控将要出现键盘的方法
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.toolBar.frame = CGRectMake(0, 416-kbSize.height, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}
//监控键盘消失的方法
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.toolBar.frame = CGRectMake(0, HEIGHT, WIDTH, toolBarHeight);
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self setNearTabelView:nil];
    [self setActivityView:nil];
    [self setMyTableView:nil];
    [self setMyMapView:nil];
    [self setSearchBar:nil];
    [self setToolBar:nil];
    [self setSearch:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [myMapView release];
    [myTableView release];
    [nearTabelView release];
    [activityView release];
    [toolbar release];
    [searchBar release];
    [search release];
    [place release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
