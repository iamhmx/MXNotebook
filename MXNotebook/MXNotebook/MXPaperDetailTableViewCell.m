//
//  MXPaperDetailTableViewCell.m
//  MXNotebook
//
//  Created by yellow on 2017/8/9.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXPaperDetailTableViewCell.h"
#import "MXTopic.h"
#import "MXPaper.h"

@interface MXPaperDetailTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTf;
@property (weak, nonatomic) IBOutlet UITextField *amountTf;
@property (strong, nonatomic) NSDateFormatter *format;
@property (strong, nonatomic) UITapGestureRecognizer *tapGes;
@property (weak, nonatomic) IBOutlet UIImageView *cellArrowImageView;
@end

@implementation MXPaperDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentTf.delegate = self;
    self.amountTf.delegate = self;
    self.baseView.layer.cornerRadius = 5;
    self.baseView.layer.borderWidth = 1.5;
    self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:self.tapGes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChangeed:) name:@"NewDate" object:nil];
}

- (void)setType:(PaperDetailType)type Topic:(MXTopic*)topic andPaper:(MXPaper*)paper {
    //self.cellArrowImageView.hidden = type == PaperAdd ? NO : YES;
    self.baseView.layer.borderColor = [topic.topicColor colorWithAlphaComponent:0.8].CGColor;
    self.topicLabel.text = topic.name;
    //self.topicLabel.textColor = topic.topicColor;
    if (type == PaperAdd) {
        self.timeLabel.text = [self.format stringFromDate:[NSDate date]];
    } else if (type == PaperUpdate) {
        self.timeLabel.text = [self.format stringFromDate:paper.date];
        self.contentTf.text = paper.name;
        self.amountTf.text = [NSString stringWithFormat:@"%.2f",paper.amount];
    }
}

- (void)dateChangeed:(NSNotification*)noti {
    NSDate *date = noti.object;
    self.timeLabel.text = [self.format stringFromDate:date];
}

- (void)setChooseDate:(NSDate *)chooseDate {
    _chooseDate = chooseDate;
    self.timeLabel.text = [self.format stringFromDate:chooseDate];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldFinishContent:price:)]) {
        [self.delegate textFieldFinishContent:self.contentTf.text price:self.amountTf.text];
    }
}

- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(tapDateCell)]) {
        [self.delegate tapDateCell];
    }
}

- (NSDateFormatter *)format {
    if (!_format) {
        _format = [[NSDateFormatter alloc]init];
        [_format setDateFormat:@"yyyy年MM月dd日"];
        _format.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    }
    return _format;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
