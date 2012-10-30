
#import "SearchMassage.h"

@implementation SearchMassage

@synthesize placeName = _placeName;//当前位置的名字
@synthesize placeLat = _placeLat;//当前位置的纬度
@synthesize placeLon = _placeLon;//当前位置的经度
@synthesize placeMess = _placeMess;//当前位置详细信息
@synthesize nearbyArray = _nearbyArray;//存放附近信息的数组
@synthesize searchArray = _searchArray;//

-(void)dealloc
{
    [_placeMess release];
    [_placeName release];
    [_nearbyArray release];
    [_searchArray release];
    [super dealloc];
}

@end
