//
//  MXPaperListBottomView.h
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaperListBottomAction)(NSInteger index);

@interface MXPaperListBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame action:(PaperListBottomAction)action;

- (void)animationEditButton;

- (void)animationTotalButton;

@end
