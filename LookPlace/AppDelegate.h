//
//  AppDelegate.h
//  LookPlace
//
//  Created by Ibokan on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ShareApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define IS_FIRST_RUN  @"isFirstRun"
@class RootViewController;
@class NowPlaceViewController;
@class FuWuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;//定义位置管理器
    CLLocationDegrees lat;//定义经度
    CLLocationDegrees lon;//定义纬度

    CLLocationCoordinate2D location;
    MKCoordinateRegion theRegion;//地图的缩放级别
    MKPointAnnotation *annotation;
    
    BOOL isFirstRun;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RootViewController *root;//主界面
@property (nonatomic, retain) FuWuViewController *fuwu;//帮助界面
@property (nonatomic, retain) NowPlaceViewController *nowPlace;//当前位置界面

@property (assign,nonatomic) MKCoordinateRegion theRegion;
@property (assign,nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, assign) BOOL isFirstRun;

-(void)location:(id)sender;

@end
