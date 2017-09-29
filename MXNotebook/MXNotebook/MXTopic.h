//
//  MXTopic.h
//  MXNotebook
//
//  Created by msxf on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <Realm/Realm.h>
#import "MXPaper.h"

@interface MXTopic : RLMObject

@property NSString *ID;
@property NSString *name;
@property NSDate *date;

/**
 一对多关系
 */
@property RLMArray <MXPaper*><MXPaper> *papers;
@property (strong, nonatomic) UIColor *topicColor;

@end
