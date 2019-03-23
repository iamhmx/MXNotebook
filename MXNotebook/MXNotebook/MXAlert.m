//
//  MXAlert.m
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXAlert.h"

#define TitleTopMargin 15
#define ButtonHeight 40
#define AnimationDuration 0.2
#define BlurAlpha 0.85

@interface MXAlert ()

/**
 window
 */
@property (strong, nonatomic) UIWindow *customWindow;

/**
 父视图
 */
@property (strong, nonatomic) UIView *baseView;

/**
 子视图
 */
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) MXTextField *textField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIView *sepLine;

/**
 数据
 */
@property (copy, nonatomic)   NSString *title;
@property (copy, nonatomic)   NSString *message;
@property (strong, nonatomic) NSArray *buttonTitleArray;
@property (copy, nonatomic)   MXAlertHandler handler;
@property (copy, nonatomic)   MXAlertDatePickerHandler datePickerHandler;
@property (assign, nonatomic) BOOL hasTextField;
@property (assign, nonatomic) BOOL hasDatePicker;
@property (assign, nonatomic) BOOL hasHud;
@end

@implementation MXAlert

+ (instancetype)shareInstance {
    static MXAlert *alert;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[MXAlert alloc] init];
    });
    return alert;
}

- (instancetype)init {
    if (self = [super init]) {
        self.customWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, [UIDevice deviceWidth], [UIDevice deviceHeight])];
        self.customWindow.backgroundColor = RgbaColor(100, 100, 100, 0.01);
        self.customWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return self;
}

+ (instancetype _Nonnull )alertWithTextField:(NSString*_Nonnull)title message:(NSString*_Nullable)message buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertHandler _Nullable )handler {
    MXAlert *alert = [MXAlert shareInstance];
    alert.title = title;
    alert.message = message;
    alert.buttonTitleArray = titles;
    alert.handler = handler;
    alert.hasTextField = YES;
    [alert setupView];
    
    [alert setupViewConstraint];
    
    return alert;
}

+ (instancetype _Nonnull )alertWithTitle:(NSString*_Nonnull)title buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertHandler _Nullable )handler {
    MXAlert *alert = [MXAlert shareInstance];
    alert.title = title;
    alert.buttonTitleArray = titles;
    alert.handler = handler;
    [alert setupView];
    
    [alert setupViewConstraint];
    
    return alert;
}

+ (instancetype _Nonnull )alertDatePickerWithTitle:(NSString*_Nonnull)title buttonTitles:(nonnull NSArray<NSString*>*)titles action:(MXAlertDatePickerHandler _Nullable )handler {
    MXAlert *alert = [MXAlert shareInstance];
    alert.title = title;
    alert.buttonTitleArray = titles;
    alert.datePickerHandler = handler;
    alert.hasDatePicker = YES;
    [alert setupView];
    
    [alert setupViewConstraint];
    
    return alert;
}

+ (void)hud:(NSString*_Nonnull)title {
    MXAlert *alert = [MXAlert shareInstance];
    alert.title = title;
    alert.hasHud = YES;
    [alert setupView];
    
    [alert setupViewConstraint];
    
    [alert showDuration:1.0];
}

- (void)setType:(ShowAnimationType)type {
    _type = type;
    //[self setupView];
    //[self setupViewConstraint];
}

- (void)addTextField:(void(^_Nullable)(MXTextField *textField))TextFieldConfigure {
    if (TextFieldConfigure) {
        TextFieldConfigure(self.textField);
    }
}

- (void)addTitle:(void(^_Nullable)(UILabel * _Nullable label))titleConfigure {
    if (titleConfigure) {
        titleConfigure(self.titleLabel);
    }
}

- (void)addDatePicker:(void (^)(UIDatePicker * _Nullable))pickerConfigure {
    if (pickerConfigure) {
        pickerConfigure(self.datePicker);
    }
}

- (void)setupView {
    /*if (self.type == MXFade) {
        
    } else if (self.type == MXBlur) {
        [self.customWindow addSubview:self.effectView];
    }*/
    
    [self.customWindow addSubview:self.effectView];
    
    [self.customWindow addSubview:self.baseView];
    
    [self.baseView addSubview:self.titleLabel];
    
    if (self.message.length > 0) {
        [self.baseView addSubview:self.messageLabel];
    }
    if (self.hasTextField) {
        [self.baseView addSubview:self.textField];
    }
    if (self.hasDatePicker) {
        [self.baseView addSubview:self.datePicker];
    }
    if (self.buttonTitleArray.count > 0) {
        [self setupButtons:self.buttonTitleArray];
    }
}

- (void)setupViewConstraint {
    /*if (self.type == MXBlur) {
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.customWindow);
        }];
    }*/
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.customWindow);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(TitleTopMargin);
        make.left.equalTo(self.baseView.mas_left).offset(15);
        make.right.equalTo(self.baseView.mas_right).offset(-15);
    }];
    
    if (self.message.length > 0) {
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.baseView.mas_left).offset(20);
            make.right.equalTo(self.baseView.mas_right).offset(-20);
        }];
    }
    
    if (self.hasTextField) {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.message.length > 0) {
                make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            }
            make.left.equalTo(self.baseView).offset(20);
            make.right.equalTo(self.baseView).offset(-20);
            make.height.equalTo(@(35));
        }];
    }
    
    if (self.hasDatePicker) {
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.right.equalTo(self.baseView);
            make.height.equalTo(@(150));
        }];
    }
    
    if (self.buttonTitleArray.count > 0) {
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.hasTextField) {
                make.top.equalTo(self.textField.mas_bottom).offset(TitleTopMargin);
            } else {
                if (!self.hasDatePicker) {
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(TitleTopMargin);
                } else {
                    make.top.equalTo(self.datePicker.mas_bottom);
                }
            }
            make.left.right.equalTo(self.baseView);
            make.height.equalTo(@(0.5));
        }];
        
        if (self.buttonTitleArray.count == 2) {
            [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.baseView);
                make.width.equalTo(self.baseView).multipliedBy(0.5);
                make.height.equalTo(@(ButtonHeight));
                make.top.equalTo(self.sepLine.mas_bottom);
            }];
            
            [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.baseView);
                make.width.equalTo(self.baseView).multipliedBy(0.5);
                make.height.equalTo(@(ButtonHeight));
                make.top.equalTo(self.sepLine.mas_bottom);
            }];
            
            UIView *lineMid = [UIView new];
            lineMid.backgroundColor = [UIColor lightGrayColor];
            [self.baseView addSubview:lineMid];
            [lineMid mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sepLine.mas_bottom);
                make.centerX.equalTo(self.baseView);
                make.width.equalTo(@(0.5));
                make.bottom.equalTo(self.leftButton.mas_bottom);
            }];
        } else {
            [self.baseView addSubview:self.leftButton];
            [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.width.equalTo(self.baseView);
                make.height.equalTo(@(ButtonHeight));
                make.top.equalTo(self.sepLine.mas_bottom);
            }];
        }
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.customWindow);
            make.width.equalTo(self.customWindow).multipliedBy(0.75);
            make.bottom.equalTo(self.leftButton.mas_bottom);
        }];
    } else {
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.customWindow);
            make.width.equalTo(self.customWindow).multipliedBy(0.75);
            make.bottom.equalTo(self.titleLabel.mas_bottom).offset(TitleTopMargin);
        }];
    }
}

- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.customWindow.hidden = NO;
    self.effectView.alpha = 0;
    self.baseView.alpha = 0;
    [self.customWindow makeKeyAndVisible];
    [UIView animateWithDuration:AnimationDuration animations:^{
        /*if (self.type == MXFade) {
            self.customWindow.backgroundColor = RgbaColor(100, 100, 100, 0.7);
        } else if (self.type == MXBlur) {
            self.effectView.alpha = BlurAlpha;
        }*/
        self.effectView.alpha = BlurAlpha;
        self.baseView.alpha = 1;
    } completion:^(BOOL finished) {
        //[self.textField becomeFirstResponder];
    }];
}

- (void)showDuration:(CGFloat)duration {
    self.customWindow.hidden = NO;
    self.effectView.alpha = 0;
    self.baseView.alpha = 0;
    [self.customWindow makeKeyAndVisible];
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.effectView.alpha = BlurAlpha;
        self.baseView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
}

- (void)hide {
    [UIView animateWithDuration:AnimationDuration animations:^{
        /*if (self.type == MXFade) {
            self.customWindow.backgroundColor = RgbaColor(100, 100, 100, 0.01);
        } else if (self.type == MXBlur) {
            self.effectView.alpha = 0;
        }*/
        self.effectView.alpha = 0;
        self.baseView.alpha = 0;
    } completion:^(BOOL finished) {
        self.customWindow.hidden = YES;
        [self clean];
    }];
}

- (void)setupButtons:(NSArray <NSString*>*)buttonTitles {
    self.sepLine = [UIView new];
    self.sepLine.backgroundColor = [UIColor lightGrayColor];
    [self.baseView addSubview:self.sepLine];
    
    if (buttonTitles.count == 2) {
        //两个按钮
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
        self.leftButton.tag = 0;
        [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:ThemeColor forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        self.rightButton.tag = 1;
        [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:self.rightButton];
        
        
    } else {
        //一个按钮
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.tag = 0;
        [self.leftButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
}

- (void)buttonClicked:(UIButton*)btn {
    //注意顺序，先回调，再清理
    if (self.handler) {
        if (self.hasTextField) {
            self.handler(btn.tag, self.textField.text);
        } else {
            self.handler(btn.tag, self.titleLabel.text);
        }
    }
    if (self.datePickerHandler) {
        if (self.hasDatePicker) {
            self.datePickerHandler(btn.tag, self.datePicker.date);
        }
    }
    [self hide];
}

#pragma mark privite

- (void)clean {
    self.hasTextField = NO;
    self.hasDatePicker = NO;
    self.hasHud = NO;
    self.title = nil;
    self.message = nil;
    self.buttonTitleArray = nil;
    
    //单例属性一直存在，手动清理
    for (UIView *view in self.baseView.subviews) {
        [view removeFromSuperview];
    }
    _titleLabel = nil;
    _messageLabel = nil;
    _textField = nil;
    _datePicker = nil;
    _leftButton = nil;
    _rightButton = nil;
    [_baseView removeFromSuperview];
    _baseView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)noti {
    CGFloat curkeyBoardHeight = [[[noti userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[noti userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[noti userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSNumber *duration = [noti userInfo][@"UIKeyboardAnimationDurationUserInfoKey"];
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if (begin.size.height > 0 && (begin.origin.y - end.origin.y > 0)) {
        [self.customWindow layoutIfNeeded];
        [UIView animateWithDuration:[duration floatValue] delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:25 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.customWindow);
                make.width.equalTo(self.customWindow).multipliedBy(0.7);
                make.bottom.equalTo(self.leftButton.mas_bottom);
                make.bottom.equalTo(self.customWindow.mas_bottom).offset(-curkeyBoardHeight - 100);
            }];
        } completion:^(BOOL finished) {
            
        }];
        [self.customWindow layoutIfNeeded];
    }
}

- (void)setBlurAlpha:(CGFloat)blurAlpha {
    self.effectView.alpha = blurAlpha;
}

#pragma mark getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc]init];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.cornerRadius = 5;
        _baseView.layer.masksToBounds = YES;
        _baseView.layer.shadowColor = ThemeColor.CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(5, 5);
        _baseView.layer.shadowRadius = 3;
        _baseView.layer.shadowOpacity = 0.8;
    }
    return _baseView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.alpha = BlurAlpha;
    }
    return _effectView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.text = self.message;
    }
    return _messageLabel;
}

- (MXTextField *)textField {
    if (!_textField) {
        _textField = [[MXTextField alloc]init];
        //_textField.font = [UIFont systemFontOfSize:17];
        _textField.layer.cornerRadius = 5;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.layer.borderWidth = 0.5;
    }
    return _textField;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //默认根据手机本地设置显示为中文还是其他语言，设置为中文显示
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        //当前时间创建NSDate
        _datePicker.date = [NSDate date];
        //设置最大值时间
        _datePicker.maximumDate = [NSDate date];
        
        for (UIView *view in _datePicker.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UIDatePickerView")]) {
                view.backgroundColor = [UIColor whiteColor];
                UIView *colorView = [[UIView alloc] init];
                colorView.backgroundColor = [UIColor blueColor];
                colorView.alpha = 0.1f;
                [view addSubview:colorView];
                [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(view);
                    make.width.equalTo(view);
                    make.height.equalTo(@(35));
                }];
            }
        }
    }
    return _datePicker;
}

@end
