//
//  UIDevice+Model.m
//  MXNotebook
//
//  Created by msxf on 2019/3/23.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "UIDevice+Model.h"

@implementation UIDevice (Model)
+ (BOOL)isIphoneXOrLater {
    BOOL iPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.top > 24.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}
+ (CGFloat)navHeight {
    return [self isIphoneXOrLater] ? 88.0 : 64.0;
}
+ (CGFloat)statusBarHeight {
    return [self isIphoneXOrLater] ? 44.0 : 20.0;
}
+ (CGFloat)tabBarHeight {
    return [self isIphoneXOrLater] ? 83.0 : 49.0;
}
+ (CGFloat)deviceWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)deviceHeight {
    return [UIScreen mainScreen].bounds.size.height;
}
+ (CGFloat)screenHeight {
    return [self isIphoneXOrLater] ? [self deviceHeight] - 34.0 : [self deviceHeight];
}
+ (CGFloat)screenHeightNoNav {
    return [self screenHeight] - [self navHeight];
}
+ (CGFloat)screenHeightNoNavNoTab {
    return [self screenHeight] - [self navHeight] - [self tabBarHeight];
}
@end
