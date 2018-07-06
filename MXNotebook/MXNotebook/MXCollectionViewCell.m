//
//  MXCollectionViewCell.m
//  MXNotebook
//
//  Created by yellow on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXCollectionViewCell.h"
#import "MXTopic.h"

#define Angle(a) (M_PI_2/90 * a)

@interface MXCollectionViewCell ()
@property (strong, nonatomic) NSDateFormatter *dateFormat;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (strong, nonatomic) MXTopic *topic;
@property (assign, nonatomic) NSInteger radio;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL setBackgroundColor;
@end

@implementation MXCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    
//    if (!self.setBackgroundColor) {
//        self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.6];
//        self.setBackgroundColor = YES;
//    }
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPressGes];
}

- (void)setTopic:(MXTopic*)topic {
    self.backgroundColor = topic.topicColor;
    self.nameLabel.text = topic.name;
    self.timeLabel.text = [self.dateFormat stringFromDate:topic.date];
    if (topic.papers.count > 0) {
        self.totalNumLabel.hidden = NO;
        self.totalNumLabel.text = [NSString stringWithFormat:@"%ld",topic.papers.count];
        self.totalNumLabel.textColor = [topic.topicColor colorWithAlphaComponent:1];
    } else {
        self.totalNumLabel.hidden = YES;
    }
}

- (void)setShowDeleteAnimation:(BOOL)showDeleteAnimation {
    _showDeleteAnimation = showDeleteAnimation;
    if (showDeleteAnimation) {
        self.deleteButton.hidden = NO;
        [self startDeleteAnimation];
    } else {
        self.deleteButton.hidden = YES;
        [self closeDeleteAnimation];
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellDelete:)]) {
        [self.delegate cellDelete:self.indexPath];
    }
}

- (void)startAnimation:(MXSelectCellAnimationType)type Compeletion:(void(^)())handler {
    if (type == Rotate) {
        [self setAnchorPoint:CGPointMake(0.5, 0)];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = CATransform3DMakeRotation(Angle(8), 0, 0, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.layer.transform = CATransform3DMakeRotation(Angle(4), 0, 0, -1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.layer.transform = CATransform3DMakeRotation(Angle(6), 0, 0, 1);
                } completion:^(BOOL finished) {
                    self.layer.transform = CATransform3DIdentity;
                    [self setDefaultAnchorPoint];
                    if (handler) {
                        handler();
                    }
                    /*[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     self.layer.transform = CATransform3DMakeRotation(Angle(5), 0, 0, -1);
                     } completion:^(BOOL finished) {
                     self.layer.transform = CATransform3DIdentity;
                     [self setDefaultAnchorPoint];
                     if (handler) {
                     handler();
                     }
                     }];*/
                }];
            }];
        }];
    } else if (type == Scale) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
            } completion:^(BOOL finished) {
                self.layer.transform = CATransform3DIdentity;
                if (handler) {
                    handler();
                }
            }];
        }];
    }
}

- (void)startDeleteAnimation {
    self.layer.transform = CATransform3DIdentity;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)closeDeleteAnimation {
    self.layer.transform = CATransform3DIdentity;
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)longPressAction:(id)sender {
    if (self.showDeleteAnimation) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(cellLongPressed:)]) {
        [self.delegate cellLongPressed:self.indexPath];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

- (void)setDefaultAnchorPoint {
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f)];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
                    self.layer.transform = CATransform3DRotate(CATransform3DMakeTranslation(self.x, self.y, 0), Angle(self.radio), 0, 0, 1);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
                    self.layer.transform = CATransform3DRotate(CATransform3DMakeTranslation(-self.x, -self.y, 0), Angle(self.radio), 0, 0, -1);
                }];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (NSDateFormatter *)dateFormat {
    if (!_dateFormat) {
        _dateFormat = [[NSDateFormatter alloc]init];
        [_dateFormat setDateFormat:@"yyyy年MM月dd日"];
        _dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _dateFormat;
}

- (NSInteger)radio {
    return arc4random() % 2;
}

- (CGFloat)x {
    return (arc4random() % 20) / 10.0;
}

- (CGFloat)y {
    return (arc4random() % 20) / 10.0;
}

@end
