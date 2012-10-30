//
//  DataCollect.h
//  _LookForPlace
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define kDataBasePath @"dataBase.sqlite"

@interface DataCollect : NSObject

//打开数据库
+(sqlite3 *)openDataBase;

//关闭数据库
+(void)closeDataBase;

@end
