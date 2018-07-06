//
//  MXAlert.h
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MXAlertHandler)(NSInteger index, NSString * _Nullable text);
typedef void(^MXAlertDatePickerHandler)(NSInteger index, NSDate * _Nullable date);

typedef NS_ENUM(NSInteger, ShowAnimationType) {
    MXFade,
    MXBlur
};

@interface MXAlert : NSObject

@property (assign, nonatomic) ShowAnimationType type;
@property (assign, nonatomic) CGFloat blurAlpha;

+ (instancetype _Nonnull )shareInstance;


/**
 带有textFiled的alert

 @param title title
 @param message message
 @param titles buttons
 @param handler handler
 @return void
 */
+ (instancetype _Nonnull )alertWithTextField:(NSString*_Nonnull)title message:(NSString*_Nullable)message buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertHandler _Nullable )handler;

- (void)addTextField:(void(^_Nullable)(MXTextField * _Nullable textField))TextFieldConfigure;

/**
 只带title

 @param title title description
 @param titles titles description
 @param handler handler description
 @return return value description
 */
+ (instancetype _Nonnull )alertWithTitle:(NSString*_Nonnull)title buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertHandler _Nullable )handler;

- (void)addTitle:(void(^_Nullable)(UILabel * _Nullable label))titleConfigure;

/**
 DatePicker
 
 @param title title description
 @param titles titles description
 @param handler handler description
 @return return value description
 */
+ (instancetype _Nonnull )alertDatePickerWithTitle:(NSString*_Nonnull)title buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertDatePickerHandler _Nullable )handler;

- (void)addDatePicker:(void(^_Nullable)(UIDatePicker * _Nullable picker))pickerConfigure;


/**
 Toast

 @param title title
 */
+ (void)hud:(NSString*_Nonnull)title;

- (void)show;

@end
