//
//  ShareWeiboViewController.h
//  ShareWeibo
//
//  Created by Ibokan on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthManager.h"
#import "ASIHTTPRequest.h"

@interface ShareWeiboViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
    UIImageView *myImageView;
    OAuthManager *sinaOAuthManager;
    OAuthManager *tencentOAuthManager;

}

@property (nonatomic, retain) NSString *musicStr;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) UIImagePickerController *picker;


@end
