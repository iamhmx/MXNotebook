//
//  Constants.h
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//颜色
#define RgbColor(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RgbaColor(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 16进制颜色
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define BLOCKSELF __weak typeof (self) blockSelf = self;

#define KeyWindow ([[UIApplication sharedApplication].delegate window])

#define ThemeColor RgbColor(64, 143, 242)

#endif /* Constants_h */
