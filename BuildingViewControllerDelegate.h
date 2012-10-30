//
//  BuildingViewControllerDelegate.h
//  LookPlace
//
//  Created by Ibokan on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BuildingViewControllerDelegate <NSObject>

-(void)passBuildingMessage:(NSString *)buildingMessage;

@end
