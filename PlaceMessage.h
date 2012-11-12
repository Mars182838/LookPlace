//
//  PlaceMessage.h
//  _LookForPlace
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceMessage : NSObject
{
    NSMutableArray *placeArray;
}

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, assign) double placeLat;
@property (nonatomic, assign) double placeLon;
@property (nonatomic, copy) NSString *placeMess;
@property (nonatomic, copy) NSString *ceKaoName;
@property (nonatomic, copy) NSString *baoCunName;
@property (nonatomic, retain) UIImage *imageData;
@property (nonatomic, copy) NSString *addMessage;

//自己写的初使化的方法
-(id)initWithID:(int)newID andPlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage;
//查找表中的所有信息
+(NSMutableArray *)findAllMessage;

//查看表中有多少信息
+(int)count;

//判断名字是存在
+(BOOL)isExistWithName:(NSString *)theName;

//添加新的信息 返回值用来
+(int)addPlaceWithPlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName  andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage;

//修改
+(int)upDatePlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage fromID:(int)ID;

//删除
+(int)deletePalceID:(NSInteger)theID;

@end


