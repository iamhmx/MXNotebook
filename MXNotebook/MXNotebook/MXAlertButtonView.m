//
//  MXAlertButtonView.m
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXAlertButtonView.h"
#import <Masonry/Masonry.h>

#define LineColor [UIColor colorWithRed:159 green:159 blue:159 alpha:0.8]
#define BtnViewWidth (SCREEN_WIDTH * 3 / 4)
#define BtnViewHight 35

@implementation MXAlertButtonView

- (instancetype)initWithLeftButton:(NSString*)left rightButton:(NSString*)right {
    if (self = [super init]) {
        UIView *lineTop = [UIView new];
        lineTop.backgroundColor = LineColor;
        
        [self addSubview:lineTop];
        [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
        
        if (left.length > 0 && right.length > 0) {
            //有两个按钮
            UIView *lineMid = [UIView new];
            lineMid.backgroundColor = LineColor;
            [self addSubview:lineMid];
            [lineMid mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineTop.mas_bottom);
                make.width.equalTo(@(0.5));
                make.bottom.equalTo(self.mas_bottom);
                make.centerX.equalTo(self);
            }];
            
            /*UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftBtn setTitle:left forState:UIControlStateNormal];
            [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:leftBtn];
            [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self);
                make.top.equalTo(lineTop.mas_bottom).offset(0.5);
                make.right.equalTo(lineMid.mas_left).offset(-0.5);
            }];
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setTitle:right forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self addSubview:rightBtn];
            [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineMid.mas_right).offset(0.5);
                make.top.equalTo(lineTop.mas_bottom).offset(0.5);
                make.bottom.right.equalTo(self);
            }];*/
        } else {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:right.length > 0 ? right : left forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(lineTop.mas_bottom);
            }];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
