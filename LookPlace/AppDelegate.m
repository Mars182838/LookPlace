//
//  AppDelegate.m
//  LookPlace
//
//  Created by Ibokan on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <sqlite3.h>
#import "DataCollect.h"
#import "RootViewController.h"
#import "FuWuViewController.h"
#import "NowPlaceViewController.h"

@implementation AppDelegate
@synthesize theRegion;
@synthesize location;

@synthesize window = _window;
@synthesize fuwu = _fuwu;
@synthesize root = _root;
@synthesize nowPlace = _nowPlace;
@synthesize isFirstRun;

- (void)dealloc
{
    [_root release];
    [_nowPlace release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self location:nil];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    isFirstRun = [[[NSUserDefaults standardUserDefaults] valueForKey:IS_FIRST_RUN] boolValue];
    if (!isFirstRun) {
       [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:IS_FIRST_RUN] ;
        FuWuViewController *fuwu = [[FuWuViewController alloc] initWithNibName:nil bundle:nil];
        fuwu.isFirst = isFirstRun;
        self.window.rootViewController = fuwu;
        
        sqlite3 *dataBase;
        dataBase = [DataCollect openDataBase];
        char *errorMsg; 
        const char *createSql="create table if not exists 'lookPlace' (id integer primary key, placename text,placelat integer,placelon integer,placemess text,cekaoname text,baocunname text,imagedata blob,fujinxinxi text)";
        if (sqlite3_exec(dataBase, createSql, NULL, NULL, &errorMsg) == SQLITE_OK) { 
        }
        if (errorMsg!=nil) {
            NSLog(@"%s",errorMsg);
        }
        [DataCollect closeDataBase];
    }
    else {
        //不是第一次运行时到主界面
        RootViewController *rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        self.root = rootView;
        self.window.rootViewController = self.root;
        [rootView release];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - CLLocationManager Delegate Methods
-(void)location:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];//初始化位置管理器
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
        locationManager.distanceFilter = 1000.0f;//设置距离筛选器
        [locationManager startUpdatingLocation];//启动位置管理器
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{    
       
    location = [newLocation coordinate];//当前经纬 
    //插针的经纬  有偏移量 
    lat = location.latitude;
    lon = location.longitude;
    
    MKCoordinateSpan theSpan; 
    theSpan.latitudeDelta = 0.01f; 
    theSpan.longitudeDelta = 0.01f; 
    theRegion.center = location; 
    theRegion.span = theSpan;
    
    [locationManager stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
