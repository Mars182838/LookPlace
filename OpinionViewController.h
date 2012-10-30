//
//  OpinionViewController.h
//  LookPlace
//
//  Created by Ibokan on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,NSURLConnectionDelegate>

{
    BOOL backKeyboard;
    NSURLConnection *coonection;
    NSMutableData *mutableData;
}
@property (retain, nonatomic) IBOutlet UILabel *opinionLabel;
@property (retain, nonatomic) IBOutlet UILabel *email;
@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UITextView *opinionTextView;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) UIToolbar *toolbar;

- (IBAction)buttonPress:(id)sender;

@end
