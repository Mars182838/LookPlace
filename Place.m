//
//  Place.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize title;
@synthesize subTitle;
@synthesize coordinate;

-(id)initWithCoordinates:(CLLocationCoordinate2D)coords
{
    self = [super init];
    if (self) {
        coordinate = coords;
    }
    return self;
}

-(NSString *)title
{
    return title;
}
//返回详细信息
-(NSString *)subtitle
{
    return subTitle;
}

-(void)dealloc
{
    [title release];
    [subTitle release];
    [super dealloc];
}

@end
