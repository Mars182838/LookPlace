//
//  Place.h
//  _LookForPlace
//
//  Created by Ibokan on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id)initWithCoordinates:(CLLocationCoordinate2D)coords;

@end
