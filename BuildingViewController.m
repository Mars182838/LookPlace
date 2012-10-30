
#import "BuildingViewController.h"
#import "PlaceMessageViewController.h"
#import "OpinionViewController.h"
#import "NowPlaceViewController.h"
#import "SearchMassage.h"
#import "PlaceMark.h"
#import "Const.h"

@implementation BuildingViewController
@synthesize activityView;//指示器
@synthesize mytableView;//参照物的信息
@synthesize buildingLat;//当前的位置的纬度
@synthesize buildingLon;//当前的位置的经度 
@synthesize cankaoLat;//附近位置的纬度
@synthesize cankaoLon;//附近位置的经度
@synthesize buildName;//建筑物的名称
@synthesize delegate;//代理
@synthesize distance;//建筑物的距离
@synthesize direction;//建筑物的方向

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    
    search = [[SearchMassage alloc] init];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(150, 150, 30, 30);
    [self.mytableView addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelector:@selector(praserNearybyGOOGLE)];
    });
}

#pragma mark JsonPraser
//解析json数据
-(void)praserNearybyGOOGLE
{   
    // https://maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=1000&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c
    NSString *jsonData;
    jsonData = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&hl=zh-CN&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c",buildingLat,buildingLon];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonData]];
    id jsonPraser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
    search.nearbyArray = [jsonPraser objectForKey:@"results"];
    int count = [search.nearbyArray count];
    search.nearbyArray = [search.nearbyArray subarrayWithRange:NSMakeRange(1, count - 2)];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self.mytableView reloadData];//刷新数据
        [activityView stopAnimating];//数据更新完后停止
    });
    dispatch_release(mainQueue);
}

#pragma mark - 
#pragma mark UItableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return search.nearbyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cankaoLat =[[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lat"] doubleValue];//参考物的纬度
    cankaoLon = [[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"] doubleValue];//参考物的经度
    CLLocation *location = [[CLLocation alloc] initWithLatitude:cankaoLat longitude:cankaoLon];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:buildingLat longitude:buildingLon];
    //计算距离
    distance = [NSString stringWithFormat:@"%0.0f",[location1 distanceFromLocation:location]];
    [location1 release];
    [location release];
    //计算方向
    direction = [self jisuanFangwei:buildingLat andlon:buildingLon andcankaolat:cankaoLat andcnakaolon:cankaoLon];
    NSString *detail = [NSString stringWithFormat:@"%@ 距离%@米",direction,distance];
    static NSString *indentifer = @"indentifer";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifer];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifer] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.image = [UIImage imageNamed:@"店名.png"];
        }
    if (indexPath.row %2 == 0) {
        cell.contentView.backgroundColor = Text_color;
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = detail;
    return cell;
}
//选择cell时传参数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cankaoLat =[[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lat"] doubleValue];//参考物的纬度
    cankaoLon = [[[[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"] doubleValue];//参考物的经度
    CLLocation *location = [[CLLocation alloc] initWithLatitude:cankaoLat longitude:cankaoLon];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:buildingLat longitude:buildingLon];
    distance = [NSString stringWithFormat:@"%0.0f",[location1 distanceFromLocation:location]];
    [location release];
    [location1 release];
    direction = [self jisuanFangwei:buildingLat andlon:buildingLon andcankaolat:cankaoLat andcnakaolon:cankaoLon];
    buildName =[NSString stringWithFormat:@"%@ %@ 距离%@米",[[search.nearbyArray objectAtIndex:indexPath.row] objectForKey:@"name"],direction,distance];
    
    [self.navigationController popViewControllerAnimated:YES];
    [delegate passBuildingMessage:buildName];
}

#pragma mark - 
#pragma mark Calculation Distance Methods
//计算方位
-(NSString *) jisuanFangwei:(double) thelat andlon:(double) thelon andcankaolat:(double) thecankaolat andcnakaolon:(double) thecankaolon
{
    NSString * fangwei = [[[NSString alloc] init] autorelease];
    double d = atan2((thecankaolat-thelat),(thecankaolon-thelon));
    double degree = d/M_PI*180;
    if(degree <= abs(15)){
        fangwei = @"正东方向";
    }else if(degree > 15 &&  degree <= 75){
        fangwei = @"偏东北方向";
    }else if(degree > 75 &&  degree <= 105){
        fangwei = @"正北方向";
    }else if(degree > -75 && degree <= -15){
        fangwei = @"偏东南方向";
    }else if(degree > -105 && degree<= -75){
        fangwei = @"正南方向";
    }else if(degree > -165 && degree <= -105){
        fangwei = @"偏西南方向";
    }else if(degree > abs(165)){
        fangwei = @"正西方向";
    }else if(degree > 105 && degree <= 165){
        fangwei = @"偏西北方向";
    }
    return fangwei;
}

- (IBAction)buttonPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.buildName = nil;
    self.distance = nil;
    self.direction = nil;
    [self setMytableView:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [buildName release];
    [distance release];
    [direction release];
    [activityView release];
    [mytableView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
