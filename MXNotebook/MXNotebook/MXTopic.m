//
//  MXTopic.m
//  MXNotebook
//
//  Created by msxf on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXTopic.h"

@implementation MXTopic

+ (NSString *)primaryKey {
    return @"ID";
}

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"topicColor"];
}

@end
