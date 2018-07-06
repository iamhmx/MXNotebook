//
//  MXTextField.h
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXTextField : UITextField

@property (strong, nonatomic) UIFont *placeholderFont;
@property (assign, nonatomic) NSTextAlignment placeholderTextAlignment;
@property (strong, nonatomic) UIColor *placeholderColor;

@end
