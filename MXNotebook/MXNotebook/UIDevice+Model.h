//
//  UIDevice+Model.h
//  MXNotebook
//
//  Created by msxf on 2019/3/23.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Model)
+ (BOOL)isIphoneXOrLater;
// 导航栏高度
+ (CGFloat)navHeight;
// 状态栏高度
+ (CGFloat)statusBarHeight;
// tabBar高度
+ (CGFloat)tabBarHeight;
// 设备宽度
+ (CGFloat)deviceWidth;
// 设备高度
+ (CGFloat)deviceHeight;
// 屏幕高度（设备高度 - 全面屏底部控制条）
+ (CGFloat)screenHeight;
// 除去导航栏的屏幕高度
+ (CGFloat)screenHeightNoNav;
// 除去导航栏和tabBar的屏幕高度
+ (CGFloat)screenHeightNoNavNoTab;
@end

NS_ASSUME_NONNULL_END
