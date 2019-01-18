//
//  LeanplumEnvPersistence.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumEnvPersistence.h"
#import <Realm/Realm.h>

@implementation LeanplumEnvPersistence

+(void)saveLeanplumEnv:(LeanplumEnv *)env {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:env];
    }];
}

+(NSArray <LeanplumEnv *> *)loadLeanplumEnvs {
    RLMResults<LeanplumEnv *> *results = [LeanplumEnv allObjects];
    NSMutableArray <LeanplumEnv *> *envs = [NSMutableArray arrayWithCapacity:results.count];
    for (int i=0;i<results.count;i++) {
        LeanplumEnv *env = [results objectAtIndex:i];
        [envs addObject:env];
    }
    return envs;
}

+(LeanplumEnv *)production {
    RLMResults<LeanplumEnv *> *results = [LeanplumEnv objectsWhere:@"apiHostName = 'api.leanplum.com'"];
    return results.firstObject;
}

+(LeanplumEnv *)productionSeed {
    LeanplumEnv *env = [LeanplumEnv new];
    env.apiHostName = @"api.leanplum.com";
    env.apiSSL = YES;
    env.socketHostName = @"dev.leanplum.com";
    env.socketPort = 443;
    return env;
}

+(LeanplumEnv *)qa {
    RLMResults<LeanplumEnv *> *results = [LeanplumEnv objectsWhere:@"apiHostName = 'leanplum-qa-1372.appspot.com'"];
    return results.firstObject;
}

+(LeanplumEnv *)qaSeed {
    LeanplumEnv *env = [LeanplumEnv new];
    env.apiHostName = @"leanplum-qa-1372.appspot.com";
    env.apiSSL = YES;
    env.socketHostName = @"dev-qa.leanplum.com";
    env.socketPort = 80;
    return env;
}

+(LeanplumEnv *)staging {
    RLMResults<LeanplumEnv *> *results = [LeanplumEnv objectsWhere:@"apiHostName = 'leanplum-staging.appspot.com'"];
    return results.firstObject;
}

+(LeanplumEnv *)stagingSeed {
    LeanplumEnv *env = [LeanplumEnv new];
    env.apiHostName = @"leanplum-staging.appspot.com";
    env.apiSSL = YES;
    env.socketHostName = @"dev-staging.leanplum.com";
    env.socketPort = 80;
    return env;
}

+(void)seedDatabase {
    if (![self production]) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:[self productionSeed]];
        }];
    }
    if (![self qa]) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:[self qaSeed]];
        }];
    }
    if (![self staging]) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:[self stagingSeed]];
        }];
    }

}

@end
