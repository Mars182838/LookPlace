
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SearchMassage;
@class PlaceMark;
@class Place;

@interface OptionalPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    //类的成员变量
    PlaceMark *placeMark;
    Place *place;
    SearchMassage *search;
    MKMapView *myMapView;
    UISearchBar *searchBar;
    UITableView *myTableView;
    UITableView *nearTabelView;
    
    UIView *tView;
    UIToolbar *toolbar;
    
    //map类的成员变量
    CLLocationDegrees lat;
    CLLocationDegrees lon;
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
