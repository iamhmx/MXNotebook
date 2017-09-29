//
//  MXPaperDetailTableViewCell.h
//  MXNotebook
//
//  Created by msxf on 2017/8/9.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXPaperDetailTableViewCellDelegate <NSObject>

- (void)textFieldFinishContent:(NSString*)content price:(NSString*)price;
- (void)tapDateCell;

@end

@class MXTopic, MXPaper;
@interface MXPaperDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) id <MXPaperDetailTableViewCellDelegate>delegate;
@property (strong, nonatomic) NSDate *chooseDate;

- (void)setType:(PaperDetailType)type Topic:(MXTopic*)topic andPaper:(MXPaper*)paper;

@end
