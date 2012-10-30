
#import <UIKit/UIKit.h>
#import "OAuthManager.h"
#import "ASIHTTPRequest.h"

@interface WeiBoViewController : UIViewController<UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIImageView *myImageView;
    OAuthManager *tencentOAuthManager;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSString *shareString;

- (IBAction)ButtonPress:(id)sender;

@end
