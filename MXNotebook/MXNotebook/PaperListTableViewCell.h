//
//  PaperListTableViewCell.h
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXPaper, MXTopic;
@interface PaperListTableViewCell : UITableViewCell

@property (assign, nonatomic) CGPoint layerPoint;
@property (assign, nonatomic) BOOL showDeleteAnimation;

- (void)setTopic:(MXTopic*)topic Paper:(MXPaper *)paper;

- (void)deleteAnimationHandler:(void(^)(void))deleteHandler;

@end
