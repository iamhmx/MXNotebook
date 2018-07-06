//
//  MXPaper.m
//  MXNotebook
//
//  Created by yellow on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXPaper.h"

@implementation MXPaper

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"dateStr"];
}

- (NSString *)dateStr {
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy.MM.dd"];
    formate.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    return [formate stringFromDate:self.date];
}

@end
