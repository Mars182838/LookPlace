//
//  URLEncode.h
//  KWViewer
//
//  Created by  ibok on 11-4-21.
//  Copyright 2011 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLEncode : NSObject {

}
+ (NSString*)URLencode:(NSString *)originalString stringEncoding:(NSStringEncoding)stringEncoding;

+(NSString *) encodeUrlStr:(NSString *)sourceString;
@end
