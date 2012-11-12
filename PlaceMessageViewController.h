
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BuildingViewControllerDelegate.h"
#import "Const.h"

@interface PlaceMessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,BuildingViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    UIToolbar *toolBar;
    MKMapView *mapView;
    UIView *view;//地图的视图
    BOOL BaoCun;//判断是否保存
    UITextField *companyName;//保存公司的名字
    UITextField *nameText;//添加公司的名字
    UITextField *fujiaField;//显示附加信息
    UILabel *messageLable;//显示参照物信息
    UITextView *textView;//显示当前的位置信息和地图
    NSString *placeMess;//当前位置的详细信息
    NSString *buildName;//建筑物的名称
    NSString *baoCunName;//保存的名字
    NSString *imageData;//保存图片
    NSString *addString;//附加信息
    UIAlertView *alterView;//警告框视图
}
@property (retain, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic, retain)IBOutlet UIButton *saveButton;

@property (nonatomic, retain) UITextField *nameText;//添加公司的名字
@property (nonatomic, retain) UITextField *addTextField;//显示附加信息
@property (nonatomic, retain) UILabel *messageLable;//显示参照物信息
@property (nonatomic, retain) UITextView *textView;//显示当前的位置信息和地图
@property (nonatomic, retain) UIToolbar *toolBar;//透明的条
@property (nonatomic, retain) NSString *placeName;//当前位置的名字
@property (nonatomic, assign) double placeLat;//当前位置的纬度
@property (nonatomic, assign) double placeLon;//当前位置的经度
@property (nonatomic, retain) NSString *placeMess;//当前位置的详细信息
@property (nonatomic, retain) NSString *buildName;//建筑物的名称
@property (nonatomic, retain) NSString *baoCunName;//保存的名字
@property (nonatomic, retain) NSString *imageData;//保存图片
@property (nonatomic, retain) NSString *addString;//附加信息
@property (nonatomic, retain) UIAlertView *alterView;//警告框视图

-(UIImage *)captureView:(UIView *)imageView;//截取图片

- (IBAction)buttonPress:(id)sender;


@end
