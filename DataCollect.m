//
//  DataCollect.m
//  _LookForPlace
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataCollect.h"
static sqlite3 *dbPointer = nil;

@implementation DataCollect

+(sqlite3 *)openDataBase
{
    //判断数据库是否打开，返回数据库指针
    if (dbPointer) {
        return dbPointer;
    }
    //从沙盒中取得sql文件
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [documentPath objectAtIndex:0];
    NSString *sqlPath = [filePath stringByAppendingPathComponent:kDataBasePath];
    //开始数据库并设置它的指针
    sqlite3_open([sqlPath UTF8String], &dbPointer);
    return dbPointer;
}

//关闭数据库
+(void)closeDataBase
{
    if (dbPointer) {
        sqlite3_close(dbPointer);
        dbPointer = nil;
    }
}

@end
