
#import <UIKit/UIKit.h>

@interface StorePlaceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *messageArray;//存放数据信息
    UITableView *myTabelView;
    BOOL delete;
}
@property (retain, nonatomic) IBOutlet UITableView *myTabelView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) NSMutableArray *messageArray;//存放数据信息

- (IBAction)buttonPress:(id)sender;

@end
