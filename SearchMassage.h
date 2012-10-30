
#import <Foundation/Foundation.h>

@interface SearchMassage : NSObject

@property (nonatomic, retain) NSString *placeName;//当前位置的名字
@property (nonatomic, assign) double placeLat;//当前位置的纬度
@property (nonatomic, assign) double placeLon;//当前位置的经度
@property (nonatomic, retain) NSString *placeMess;//当前位置详细信息
@property (nonatomic, retain) NSArray *nearbyArray;//存放附近信息的数组
@property (nonatomic, retain) NSArray *searchArray;//存放搜索的信息

@end
