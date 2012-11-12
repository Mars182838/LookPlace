
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SearchMassage;
@class PlaceMark;
@class Place;

@interface OptionalPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    //类的成员变量
    PlaceMark *placeMark;//自选位置的大头针
    Place *place;//当前位置的大头针
    SearchMassage *search;//封装数据的类
    MKMapView *myMapView;//地图
    UISearchBar *searchBar;//自选位置的搜索栏
    UITableView *myTableView;//显示搜所的位子信息
    UITableView *nearTabelView;//显示附近位置信息
    
    UIView *tView;
    UIToolbar *toolbar;
    
    //map类的成员变量
    CLLocationDegrees lat;//自选位置的纬度
    CLLocationDegrees lon;//自选位置的经度
    CLLocation *location;
    BOOL backTabelView;//判断是否弹回tableView
}

@property (retain, nonatomic) IBOutlet MKMapView *myMapView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (retain, nonatomic) UITableView *nearTabelView;
@property (nonatomic, retain) SearchMassage *search;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UIButton *imageButton;

- (IBAction)buttonPress:(id)sender;

@end
