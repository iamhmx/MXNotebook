//
//  MXPaper.h
//  MXNotebook
//
//  Created by yellow on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <Realm/Realm.h>

@interface MXPaper : RLMObject

@property NSString *topicID;
@property NSString *name;
@property NSDate *date;
@property float amount;
@property (copy, nonatomic) NSString *dateStr;

@end
RLM_ARRAY_TYPE(MXPaper)
