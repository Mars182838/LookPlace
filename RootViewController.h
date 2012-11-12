
#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
@class OptionalPlaceViewController;
@class StorePlaceViewController;
@class NowPlaceViewController;
@class MoreViewController;
@class Reachability;

@interface RootViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    OptionalPlaceViewController *optional;//自选位置模块
    StorePlaceViewController *storePlace;//收藏模块
    NowPlaceViewController *nowPlace;//当前位置模块
    MoreViewController *more;//更多位置模块
    CustomTabBarViewController *customTab;//自定义的UITabBarController
    UITabBarController *tab;
    Reachability *hostReach;
}

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, retain) UITabBarController *tab;//tabBarController的属性

- (IBAction)buttonPress:(id)sender;

@end
