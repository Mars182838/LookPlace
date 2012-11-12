
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SearchMassage.h"
@class PlaceMark;
@class Place;

@interface NowPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    MKMapView *myMapView;//地图类
    UITableView *nearTabelView;//显示附近信息
    UIActivityIndicatorView *activityView;//指示器
    SearchMassage *search;//初始化封装数据的类
    PlaceMark *placeMark;//长按时的大头针
    Place *place;//当前位置的大头针
    UIView *tView;//显示UItableView的视图
    CLLocation *location;
    BOOL backTabelView;//判断是否返回tableView
}

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;//地图类
@property (nonatomic, retain) UITableView *nearTabelView;//显示附近信息
@property (nonatomic, retain) UIActivityIndicatorView *activityView;//指示器
@property (nonatomic, retain) UIButton *imageButton;

-(IBAction)buttonPress:(id)sender;
@end
