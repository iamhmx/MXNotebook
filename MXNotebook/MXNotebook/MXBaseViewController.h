//
//  MXBaseViewController.h
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXBaseViewController : UIViewController

@property (copy, nonatomic) NSString *navTitle;
@property (assign, nonatomic) BOOL hideNavBar;

/**
 @"Default" or @"Light"
 */
@property (copy, nonatomic) NSString *barStyle;

- (void)backAction;

@end
