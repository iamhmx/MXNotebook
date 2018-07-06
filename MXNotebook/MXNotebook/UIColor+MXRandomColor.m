//
//  UIColor+MXRandomColor.m
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "UIColor+MXRandomColor.h"

@implementation UIColor (MXRandomColor)

+ (UIColor*)randomColorWithAlpah:(CGFloat)alpha {
    return [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:alpha];
}

@end
