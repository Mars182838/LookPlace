
#import <UIKit/UIKit.h>
#import "BuildingViewControllerDelegate.h"
@class SearchMassage;

@interface BuildingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    SearchMassage *search;
    UITableView *mytableView;
    NSString *buildName;//建筑物的名称
    NSString *distance;//建筑物的距离
    NSString *direction;//建筑物的方向
    double buildingLat;//当前的位置的纬度
    double buildingLon;//当前的位置的经度
    double cankaoLat;//附近位置的纬度
    double cankaoLon;//附近位置的经度
    id<BuildingViewControllerDelegate>delegate;
}

@property (retain, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSString *buildName;//建筑物的名称
@property (nonatomic, retain) NSString *distance;//建筑物的距离
@property (nonatomic, retain) NSString *direction;//建筑物的方向
@property (nonatomic, assign) double buildingLat;//当前的位置的纬度
@property (nonatomic, assign) double buildingLon;//当前的位置的经度
@property (nonatomic, assign) double cankaoLat;//附近位置的纬度
@property (nonatomic, assign) double cankaoLon;//附近位置的经度
@property (nonatomic, assign) id<BuildingViewControllerDelegate>delegate;

- (IBAction)buttonPress:(id)sender;

@end
