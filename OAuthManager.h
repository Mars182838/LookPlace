//
//  OAuthManager.h
//  BookShare
//
//  Created by Yang QianFeng on 02/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "WeiboHTTPManager.h"
#import "OAuthController.h"
#import "TokenModel.h"


@protocol OAuthControllerDelegate;
@class OAuthController;

@interface OAuthManager : NSObject 
<OAuthControllerDelegate>
{
    WeiboType _weiboType;
    
    TokenModel *_tokenModel;
    
    UINavigationController *_navController;
    OAuthController *_oauthController;
}
@property (nonatomic, retain) TokenModel *tokenModel;

- (id) initWithOAuthManager:(WeiboType)weiboType;

- (void) logout;
- (void) login;
- (BOOL) isAlreadyLogin;
- (NSDictionary *) getCommonParams;
- (void) addPrivatePostParamsForASI:(ASIFormDataRequest *)request;
- (NSString *) getOAuthDomain;

- (TokenModel *) readTokenFromStorage;
- (void) writeTokenToStorage:(TokenModel *)tokenModel;

@end
