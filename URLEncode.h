

#import <Foundation/Foundation.h>


@interface URLEncode : NSObject {

}
+ (NSString*)URLencode:(NSString *)originalString stringEncoding:(NSStringEncoding)stringEncoding;

+(NSString *) encodeUrlStr:(NSString *)sourceString;
@end
