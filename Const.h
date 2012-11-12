//
//  Const.h
//  LookPlace
//
//  Created by Ibokan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define USERKEY @"AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c"//google的KEY
#define USERKEYJIEPANG @"100620-286168892-1c638c50c3ace89a7c3774230835e15f";
#define APP ID @"100620"

#define SEARCH_URL @"http://api.jiepang.com/v1/locations/search?lat=%f&lon=%f&source=100620&count=50"
#define SEARCH_Google_URL @"http://ditu.google.com/maps/geo?q=%f,%f&output=json&oe=utf8&hl=zh-CN&sensor=true"
#define SEARCH_GOOGLE @"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000&types=%@&sensor=true&key=AIzaSyALaqx0MfPsp2aldbZbzEQAq64SwgQfZ0c"

#define Text_color [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1]
#define HEIGHT self.view.frame.size.height
#define WIDTH  self.view.frame.size.width
#define toolBarHeight 44
