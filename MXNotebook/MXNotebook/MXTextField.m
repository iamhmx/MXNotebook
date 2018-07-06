//
//  MXTextField.m
//  MXNotebook
//
//  Created by yellow on 2017/8/3.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXTextField.h"

@implementation MXTextField

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    self.attributedPlaceholder = [self placeholderAtrStr];
}

- (NSAttributedString*)placeholderAtrStr {
    if (self.placeholder && self.placeholder.length > 0) {
        //如果设置了placeholder字体或者颜色，垂直居中
        if (self.placeholderFont || self.placeholderColor) {
            NSMutableDictionary *mDict = [NSMutableDictionary new];
            if (self.placeholderFont) {
                NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
                style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - self.placeholderFont.lineHeight) / 2.0;
                [mDict setObject:style forKey:NSParagraphStyleAttributeName];
                [mDict setObject:self.placeholderFont forKey:NSFontAttributeName];
            }
            if (self.placeholderColor) {
                [mDict setObject:self.placeholderColor forKey:NSForegroundColorAttributeName];
            }
            NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:mDict];
            return aStr;
        } else {
            NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:self.placeholder];
            return aStr;
        }
    }
    return nil;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.color"];
}

- (void)setPlaceholderTextAlignment:(NSTextAlignment)placeholderTextAlignment {
    NSNumber *value = [NSNumber numberWithInteger:placeholderTextAlignment];
    [self setValue:value forKeyPath:@"_placeholderLabel.textAlignment"];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 10, 0, 10));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 10, 0, 10));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 10, 0, 10));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
