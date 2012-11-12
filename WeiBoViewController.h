
#import <UIKit/UIKit.h>
#import "OAuthManager.h"
#import "ASIHTTPRequest.h"

@interface WeiBoViewController : UIViewController<UIImagePickerControllerDelegate,ASIHTTPRequestDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    UIImageView *myImageView;
    OAuthManager *tencentOAuthManager;
    BOOL isFirst;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIButton *pictureButton;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSString *shareString;

- (IBAction)ButtonPress:(id)sender;

@end
