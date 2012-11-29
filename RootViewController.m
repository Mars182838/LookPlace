
#import "RootViewController.h"
#import "CustomTabBarViewController.h"
#import "OptionalPlaceViewController.h"
#import "StorePlaceViewController.h"
#import "NowPlaceViewController.h"
#import "MoreViewController.h"
#import "FuWuViewController.h"
#import "PlaceMessage.h"
#import "DataCollect.h"
#import "Reachability.h"

@implementation RootViewController
@synthesize tab;//tabBarController
@synthesize numberLabel;//个数的显示

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark  Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册一个通知，为了检测当前用户的网络连接状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [[Reachability reachabilityWithHostName:@"http://www.baidu.com"] retain];
    [hostReach startNotifier];
    [self performSelectorInBackground:@selector(initViewController) withObject:nil];//调用初始化方法
}


//判断当前网络的连接状态,分别有无连接，3G连接，wifi连接
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    NSString *strMessage;
    if (curStatus == NotReachable) {
        strMessage = @"现在没有网络连接";
    }
    else if(curStatus == ReachableViaWiFi){
        strMessage = @"您当前选择了Wifi网络连接";
    }
    else {
        strMessage = @"您当前选择了2G/3G网络连接";
        
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    [self performSelectorInBackground:@selector(initViewController) withObject:nil];//调用初始化方法
}

- (void)viewDidUnload
{
    self.numberLabel = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    //注销网络连接状态的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [super dealloc];
}

//更新收藏的个数显示
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    int a = [PlaceMessage count];
    NSNumber *number = [[NSNumber alloc] initWithInt:a];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",number];
    [number release];
}

#pragma mark - 
#pragma mark InitViewController
-(void)initViewController
{
    //我的收藏视图
    storePlace = [[StorePlaceViewController alloc] initWithNibName:@"StorePlaceViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:storePlace];
    nav1.navigationBarHidden = YES;
    
    //自选位置视图
    optional = [[OptionalPlaceViewController alloc] initWithNibName:@"OptionalPlaceViewController" bundle:nil];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:optional];
    nav2.navigationBarHidden = YES;
    
    //当前位置视图
    nowPlace = [[NowPlaceViewController alloc] initWithNibName:@"NowPlaceViewController" bundle:nil];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:nowPlace];
    nav3.navigationBarHidden = YES;
    
    //更多视图
    more = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    UINavigationController * nav4 = [[UINavigationController alloc] initWithRootViewController:more];
    nav4.navigationBarHidden = YES;
    
    //自定义的tabBarController视图
    customTab = [[CustomTabBarViewController alloc] init];
    customTab.viewControllers = [[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4,nil] autorelease];
    self.tab = customTab;
    [customTab release];
    [nav1 release];
    [nav2 release];
    [nav3 release];
    [nav4 release];
    [optional release];
    [storePlace release];
    [nowPlace release];
    [more release];
}

- (IBAction)buttonPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {    //进入我的收藏
            [self initViewController];
            self.tab.selectedIndex = 0;
            [self presentViewController:self.tab animated:YES completion:nil];
            break;
        }
        case 1:
        {
            //发送自选位置
            [self initViewController];
            self.tab.selectedIndex = 1;
           [self presentViewController:self.tab animated:YES completion:nil];
            break;
        }
        case 2:
        {
            //发送当前视图
            [self initViewController];
            self.tab.selectedIndex = 2;
            [self presentViewController:self.tab animated:YES completion:nil];
            break;
        }
        case 3:
        {
            //更多视图
            [self initViewController];
            self.tab.selectedIndex = 3;
            [self presentViewController:self.tab animated:YES completion:nil];
            break;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
