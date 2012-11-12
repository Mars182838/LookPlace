//
//  URLEncode.m
//  KWViewer
//
//  Created by  ibok on 11-4-21.
//  Copyright 2011 ibokanwisdom. All rights reserved.
//

#import "URLEncode.h"


@implementation URLEncode

+ (NSString*)URLencode:(NSString *)originalString stringEncoding:(NSStringEncoding)stringEncoding {
	//!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
	//%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
	NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
									@"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
									@"!", @"'", @"(", @")", @"*", nil];
		 
	NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
									 @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
									 @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
		 
	int len = [escapeChars count];
		 
	NSMutableString *temp = [[[originalString
									  stringByAddingPercentEscapesUsingEncoding:stringEncoding]
									 mutableCopy]autorelease];

	int i;
	for (i = 0; i < len; i++) {
		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
										  withString:[replaceChars objectAtIndex:i]
											 options:NSLiteralSearch
											   range:NSMakeRange(0, [temp length])];
	}

	NSString *outStr = [NSString stringWithString:temp];

	return outStr;
}

/*
 对指定的参数进行url编码
 入参sourceString 是希望进行编码的字符串
 返回值是编码后的字符串,此方法对!*'();:@&=+$,/?%#[]都做了编码
 */
+(NSString *) encodeUrlStr:(NSString *)sourceString
{
	NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																NULL,
																(CFStringRef)sourceString,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8 );
	return [encodedString autorelease];
}


@end
