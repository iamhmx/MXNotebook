//
//  MXPaperDetailViewController.h
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXPaper,MXTopic;
@interface MXPaperDetailViewController : MXBaseViewController

@property (strong, nonatomic) MXTopic *topic;
@property (strong, nonatomic) MXPaper *paper;
@property (assign, nonatomic) PaperDetailType type;

@end
