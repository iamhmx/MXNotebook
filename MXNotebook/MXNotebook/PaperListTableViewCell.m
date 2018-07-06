//
//  PaperListTableViewCell.m
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "PaperListTableViewCell.h"
#import "MXPaper.h"
#import "MXTopic.h"

@interface PaperListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (assign, nonatomic) CGPoint originalPoint;
@property (assign, nonatomic) CGFloat paperPrice;
@property (assign, nonatomic) BOOL existDeleteAnimation;
@end

@implementation PaperListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (CGPoint)layerPoint {
    return self.originalPoint;
}

- (void)setTopic:(MXTopic*)topic Paper:(MXPaper *)paper {
    
    self.baseView.layer.borderColor = [topic.topicColor colorWithAlphaComponent:0.8].CGColor;
    self.baseView.layer.borderWidth = 1.5;
    self.paperPrice = paper.amount;
    self.timeLabel.text = paper.dateStr;
    self.contentLabel.text = paper.name;
    //self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",paper.amount];
    
    self.originalPoint = self.layer.position;
}

- (void)setShowDeleteAnimation:(BOOL)showDeleteAnimation {
    _showDeleteAnimation = showDeleteAnimation;
    if (showDeleteAnimation) {
        [self startDeleteAnimation];
    } else {
        [self closeDeleteAnimation];
    }
}

- (void)startDeleteAnimation {
    /*[UIView animateWithDuration:0.05 animations:^{
        self.priceLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.priceLabel.alpha = 1;
            self.priceLabel.text = @"删除";
        } completion:^(BOOL finished) {
            
        }];
    }];*/
    self.priceLabel.text = @"删除";
}

- (void)closeDeleteAnimation {
    /*[UIView animateWithDuration:0.05 animations:^{
        self.priceLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.priceLabel.alpha = 1;
            self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.paperPrice];
        } completion:^(BOOL finished) {
            
        }];
    }];*/
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.paperPrice];
}

- (void)deleteAnimationHandler:(void(^)(void))deleteHandler {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
