
#import "StorePlaceViewController.h"
#import "RootViewController.h"
#import "customTabelViewCell.h"
#import "EditorViewController.h"
#import "NowPlaceViewController.h"
#import "PlaceMessage.h"
@interface StorePlaceViewController ()

@end

@implementation StorePlaceViewController
@synthesize myTabelView;
@synthesize messageArray;//存储数据库里面查询到的数据
@synthesize button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delete = YES;
    myTabelView.delegate = self;
    myTabelView.dataSource = self;
    
    NSMutableArray *array = [PlaceMessage findAllMessage];
    for (int count = 0; count < [array count]; count++) {
        PlaceMessage *place = (PlaceMessage *)[array objectAtIndex:count];
        [self.messageArray insertObject:place atIndex:0];
    }
    [myTabelView reloadData];
}

#pragma mark - 
#pragma mark UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"CellIndentifier";
    customTabelViewCell *cell = (customTabelViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[customTabelViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier] autorelease];
    }
    
    PlaceMessage *message = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
    UIImage *image = message.imageData;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    imageView.image = image;
    //给图片添加一个边框
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    imageView.layer.borderColor = [UIColor purpleColor].CGColor;
    imageView.layer.borderWidth = 1;
    [cell.contentView addSubview:imageView];
    cell.nameCell.text = message.placeName;
    cell.addressCell.text = message.placeMess;
    [imageView release];
    return  cell;
}

//选中时给编辑页面传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceMessage *place = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
    EditorViewController *editor = [[EditorViewController alloc] initWithNibName:nil bundle:nil];
    editor.placeLat = place.placeLat;
    editor.placeLon = place.placeLon;
    editor.placeMess = place.placeMess;
    editor.placeName = place.placeName;
    editor.buildName = place.ceKaoName;
    editor.addString = place.addMessage;
    editor.baoCunName = place.baoCunName;
    [self.navigationController pushViewController:editor animated:YES];
    [editor release];
}
//是否可以编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选择编辑的样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.messageArray count]) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

//编辑的样式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlaceMessage *place = [self.messageArray objectAtIndex:indexPath.row];
        [PlaceMessage deletePalceID:place.ID];
        [self.messageArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationLeft];
        [myTabelView reloadData];
    }
}

- (IBAction)buttonPress:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            //返回到RootViewController中
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }    
        case 1:
        {
            //添加位置
            NowPlaceViewController *nowPlace = [[NowPlaceViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:nowPlace animated:YES];
            [nowPlace release];
            break;
        }
        case 2:
        {
            if (delete == YES) {
                [myTabelView beginUpdates];
                [myTabelView setEditing:YES animated:YES];
                [myTabelView endUpdates];
                [self.button setImage:[UIImage imageNamed:@"完成-xz.png"] forState:UIControlStateNormal];
                delete = NO;
            }
            else {
                [self.button setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
                [myTabelView setEditing:NO animated:YES];
                delete = YES;
            }
            break;
        }
    }
}

- (void)viewDidUnload
{
    [self setMyTabelView:nil];
    self.button = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    [messageArray release];
    [myTabelView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
