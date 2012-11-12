//
//  PlaceMessage.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceMessage.h"
#import "DataCollect.h"

@implementation PlaceMessage

@synthesize ID;
@synthesize placeName;//当前位置的信息
@synthesize placeLat;//当前位置的纬度
@synthesize placeLon;//当前位置的经度
@synthesize placeMess;//当前位置的详细信息
@synthesize ceKaoName;//参考的建筑物的信息
@synthesize baoCunName;//公司的名字
@synthesize imageData;//保存的图片
@synthesize addMessage;//附加的信息

//初始化数据
-(id)initWithID:(int)newID andPlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage
{
    if (self == [super init]) {
        self.ID = newID;
        self.placeName = newPlaceName;
        self.placeLat = newPlaceLat;
        self.placeLon = newPlaceLon;
        self.placeMess = newPlaceMess;
        self.ceKaoName = newCeKaoName;
        self.baoCunName = newBaoCunName;
        self.imageData = newImageData;
        self.addMessage = newAddMessage;
    }
    return self;
}

//添加数据到数据库中
+(int)addPlaceWithPlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName  andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage
{
    //打开数据库
	sqlite3 *dataBase = [DataCollect openDataBase];
	sqlite3_stmt *stmt = nil;
 
    sqlite3_prepare_v2(dataBase, "insert into lookPlace(placename,placelat,placelon,placemess,cekaoname,baocunname,imagedata,fujinxinxi) values(?,?,?,?,?,?,?,?)", -1, &stmt, nil);
    if (newPlaceName == NULL) {
        newPlaceName = @"";
    }
    if (newPlaceMess == NULL) {
        newPlaceMess = @"";
    }
    if (newCeKaoName == NULL) {
        newCeKaoName = @"";
    }
    if (newBaoCunName == NULL) {
        newBaoCunName = @"";
    }
    if (newAddMessage == NULL) {
        newAddMessage = @"";
    }
    NSData *data = UIImagePNGRepresentation(newImageData);
    sqlite3_bind_text(stmt, 1, [newPlaceName UTF8String], -1, nil);
    sqlite3_bind_double(stmt, 2, newPlaceLat);
    sqlite3_bind_double(stmt, 3, newPlaceLon);
    sqlite3_bind_text(stmt, 4, [newPlaceMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 5, [newCeKaoName UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 6, [newBaoCunName UTF8String], -1, nil);
    sqlite3_bind_blob(stmt, 7, [data bytes], [data length], NULL);
    sqlite3_bind_text(stmt, 8, [newAddMessage UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    return  result;
}

//查询数据库里面的数据
+(NSMutableArray *)findAllMessage
{
    //打开数据库
    sqlite3 *dataBase = [DataCollect openDataBase];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(dataBase, "select * from lookPlace order by placename desc", -1, &stmt, nil) == SQLITE_OK) {
        //创建一个可变数组，存放所有的信息
        NSMutableArray *array = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int theID = sqlite3_column_int(stmt, 0);
            const unsigned char *placeName = sqlite3_column_text(stmt, 1);
            double placeLat = sqlite3_column_double(stmt, 2);
            double palceLon = sqlite3_column_double(stmt, 3);
            const unsigned char *placeMess = sqlite3_column_text(stmt, 4);
            const unsigned char *ceKaoName = sqlite3_column_text(stmt, 5);
            const unsigned char *baoCunName = sqlite3_column_text(stmt, 6);
            int length = sqlite3_column_bytes(stmt, 7);
            Byte *byte = (Byte *)sqlite3_column_blob(stmt, 7);
            NSData *data = [NSData dataWithBytes:byte length:length];
            UIImage *image = [[UIImage alloc] initWithData:data];
            const unsigned char *addMessage = sqlite3_column_text(stmt, 8);
                        
            PlaceMessage *place = [[PlaceMessage alloc] initWithID:theID andPlaceName:[NSString stringWithUTF8String:(const char *) placeName ] andPlaceLat:placeLat andPlaceLon:palceLon andPlaceMess:[NSString stringWithUTF8String:(const char *) placeMess ] andCeKaoName:[NSString stringWithUTF8String:(const char *) ceKaoName] andBaoCunName:[NSString stringWithUTF8String:(const char *)baoCunName] andImageData:(UIImage *)image andAddMessage:[NSString stringWithUTF8String:(const char *)addMessage]]; 
            [array addObject:place];
            [place release];
            [image release];
        }
        //结束数据库
        sqlite3_finalize(stmt);
        return [array autorelease];
    }
    else {
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
}

//修改信息
+(int)upDatePlaceName:(NSString *)newPlaceName andPlaceLat:(double)newPlaceLat andPlaceLon:(double)newPlaceLon andPlaceMess:(NSString *)newPlaceMess andCeKaoName:(NSString *)newCeKaoName andBaoCunName:(NSString *)newBaoCunName andImageData:(UIImage *)newImageData andAddMessage:(NSString *)newAddMessage fromID:(int)ID
{
    //打开数据库
    sqlite3 *dataBase = [DataCollect openDataBase];
    sqlite3_stmt *stmt = nil;
    
    sqlite3_prepare_v2(dataBase, "update lookPlace set placename = ?,placelat = ?,placelon = ?,placemess = ?,cekaoname = ?,baocunname = ?,imagedata = ?,fujinxinxi = ? where ID=?", -1, &stmt, nil);
    if (newPlaceName == NULL) {
        newPlaceName = @"";
    }
    if (newCeKaoName == NULL) {
        newCeKaoName = @"";
    }
    if (newPlaceMess == NULL) {
        newPlaceMess = @"";
    }
    if (newBaoCunName == NULL) {
        newBaoCunName = @"";
    }
    if (newAddMessage == NULL) {
        newAddMessage = @"";
    }
    NSData *data = UIImagePNGRepresentation(newImageData);
    sqlite3_bind_text(stmt, 1, [newPlaceName UTF8String], -1, nil);
    sqlite3_bind_double(stmt, 2, newPlaceLat);
    sqlite3_bind_double(stmt, 3, newPlaceLon);
    sqlite3_bind_text(stmt, 4, [newPlaceMess UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 5, [newCeKaoName UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 6, [newBaoCunName UTF8String], -1, nil);
    sqlite3_bind_blob(stmt, 7, [data bytes], [data length], NULL);
    sqlite3_bind_text(stmt, 8, [newAddMessage UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 9, ID);
    int result = sqlite3_step(stmt);
    return result;
}

//判断名字是否正确
+(BOOL)isExistWithName:(NSString *)theName
{
    //打开数据库
    sqlite3 *db = [DataCollect openDataBase];
    sqlite3_stmt *stmt = nil;
    
	//编译sql语句，编译成功的话才能继续进行
	int result = sqlite3_prepare_v2(db, "select count(*) from lookPlace where baocunname like ?", -1, &stmt, nil);
    if(result == SQLITE_OK)
	{
        sqlite3_bind_text(stmt, 1, [theName UTF8String], -1, nil);
        
		if(sqlite3_step(stmt) == SQLITE_ROW)
		{
			int count = sqlite3_column_int(stmt, 0);
			sqlite3_finalize(stmt);//结束数据库
            BOOL isExist = count > 0 ? YES : NO;
			return isExist;
		}
	}
	else
	{
		NSLog(@"查询错误的原因是:%d",result);
	}
	sqlite3_finalize(stmt);
	return NO;
}

//计算数据库里面有多少数据
+(int)count
{
    sqlite3 *dataBase = [DataCollect openDataBase];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(dataBase, "select count(*) from lookPlace", -1, &stmt, nil);
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        int count = sqlite3_column_int(stmt, 0);
        sqlite3_finalize(stmt);//结束数据库
        return count;
    }
    else {
        NSLog(@"计算失误的:%d",result);
    }
    sqlite3_finalize(stmt);
    return 0;
}

//删除数据
+(int)deletePalceID:(NSInteger)theID
{
    //打开数据库
    sqlite3 *dataBase = [DataCollect openDataBase];
    sqlite3_stmt *stmt;
    
    sqlite3_prepare_v2(dataBase, "delete from lookPlace where ID = ?", -1, &stmt, nil);
    sqlite3_bind_int(stmt, 1, theID);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);//结束数据库
    return result;
}

-(void)dealloc
{
    [addMessage release];
    [imageData  release];
    [baoCunName release];
    [ceKaoName  release];
    [placeArray release];
    [placeMess  release];
    [placeName  release];
    [super dealloc];
}

@end
