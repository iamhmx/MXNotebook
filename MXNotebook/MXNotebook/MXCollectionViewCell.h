//
//  MXCollectionViewCell.h
//  MXNotebook
//
//  Created by msxf on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MXSelectCellAnimationType) {
    Rotate,
    Scale
};

@protocol MXCollectionViewCellDelegate <NSObject>

- (void)cellLongPressed:(NSIndexPath*)indexPath;
- (void)cellDelete:(NSIndexPath*)indexPath;

@end

@class MXTopic;
@interface MXCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id <MXCollectionViewCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL showDeleteAnimation;

- (void)setTopic:(MXTopic*)topic;

- (void)startAnimation:(MXSelectCellAnimationType)type Compeletion:(void(^)())handler;

@end
