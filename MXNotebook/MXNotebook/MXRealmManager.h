//
//  MXRealmManager.h
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef void(^RealmAction)(RLMRealm *realm);

@interface MXRealmManager : NSObject

+ (void)add:(RealmAction)action;
+ (void)remove:(RealmAction)action;
+ (void)update:(RealmAction)action;

@end
