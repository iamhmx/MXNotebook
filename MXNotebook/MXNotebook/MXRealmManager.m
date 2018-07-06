//
//  MXRealmManager.m
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXRealmManager.h"

@implementation MXRealmManager

+ (void)add:(RealmAction)action {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (action) {
        action(realm);
    }
    [realm commitWriteTransaction];
}

+ (void)remove:(RealmAction)action {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (action) {
        action(realm);
    }
    [realm commitWriteTransaction];
}

+ (void)update:(RealmAction)action {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (action) {
        action(realm);
    }
    [realm commitWriteTransaction];
}

@end
