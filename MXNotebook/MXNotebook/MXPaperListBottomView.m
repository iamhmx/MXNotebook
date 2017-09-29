//
//  MXPaperListBottomView.m
//  MXNotebook
//
//  Created by msxf on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXPaperListBottomView.h"

@interface MXPaperListBottomView ()
@property (copy, nonatomic) PaperListBottomAction buttonAction;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *totalButton;
@property (strong, nonatomic) UIButton *addButton;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) BOOL editButtonSelected;
@property (assign, nonatomic) BOOL totalButtonSelected;
@end

@implementation MXPaperListBottomView

- (instancetype)initWithFrame:(CGRect)frame action:(PaperListBottomAction)action {
    if (self = [super initWithFrame:frame]) {
        self.buttonAction = action;
        self.width = (SCREEN_WIDTH - 40) / 3.0;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.backgroundColor = [UIColor whiteColor];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.editButton.tag = 0;
    self.editButton.layer.cornerRadius = 5;
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.borderColor = [UIColor randomColorWithAlpah:0.8].CGColor;
    self.editButton.layer.borderWidth = 1.5;
    [self addSubview:self.editButton];
    
    self.totalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.totalButton setTitle:@"合计" forState:UIControlStateNormal];
    [self.totalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.totalButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.totalButton.backgroundColor = [UIColor whiteColor];
    self.totalButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.totalButton.tag = 1;
    self.totalButton.layer.cornerRadius = 5;
    self.totalButton.layer.masksToBounds = YES;
    self.totalButton.layer.borderColor = [UIColor randomColorWithAlpah:0.8].CGColor;
    self.totalButton.layer.borderWidth = 1.5;
    [self addSubview:self.totalButton];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton.backgroundColor = [UIColor whiteColor];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addButton.tag = 2;
    self.addButton.layer.cornerRadius = 5;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.borderColor = [UIColor randomColorWithAlpah:0.8].CGColor;
    self.addButton.layer.borderWidth = 1.5;
    [self addSubview:self.addButton];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@(self.width));
    }];
    
    [self.totalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.editButton.mas_right).offset(10);
        make.width.equalTo(@(self.width));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.totalButton.mas_right).offset(10);
        make.width.equalTo(@(self.width));
    }];
}

- (void)animationEditButton {
    _editButtonSelected = !_editButtonSelected;
    [self.editButton setTitle:self.editButtonSelected ? @"完成编辑" : @"编辑" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.editButton.backgroundColor = self.editButtonSelected ? [UIColor colorWithCGColor:self.editButton.layer.borderColor] : [UIColor whiteColor];
        [self.editButton setTitleColor:self.editButtonSelected ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animationTotalButton {
    _totalButtonSelected = !_totalButtonSelected;
    [UIView animateWithDuration:0.2 animations:^{
        self.totalButton.backgroundColor = self.totalButtonSelected ? [UIColor colorWithCGColor:self.totalButton.layer.borderColor] : [UIColor whiteColor];
        [self.totalButton setTitleColor:self.totalButtonSelected ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buttonAction:(UIButton*)button {
    if (button.tag == 0) {
        [self animationEditButton];
    } else if (button.tag == 1) {
        [self animationTotalButton];
    }
    if (self.buttonAction) {
        self.buttonAction(button.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
