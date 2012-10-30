//
//  costomTabelViewCell.m
//  LookPlace
//
//  Created by Ibokan on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "customTabelViewCell.h"

@implementation customTabelViewCell
@synthesize nameCell = _nameCell;
@synthesize addressCell = _addressCell;
@synthesize image;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //名字标签
        _nameCell = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 320, 30)];
        _nameCell.backgroundColor = [UIColor clearColor];
        _nameCell.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.nameCell];
        
        //地址标签
        _addressCell = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 320, 20)];
        _addressCell.font = [UIFont systemFontOfSize:14];
        _addressCell.textColor = [UIColor grayColor];
        _addressCell.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addressCell];
        //添加左边的图片
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-copy-3.png"]];    
        accessoryView.frame = CGRectMake(290, 30, 15, 15);
        [self.contentView addSubview:accessoryView];
        [accessoryView release];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
