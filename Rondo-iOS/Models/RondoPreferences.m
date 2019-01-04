//
//  RondoPreferences.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "RondoPreferences.h"
#import "LeanplumAppPersistence.h"
#import "LeanplumEnvPersistence.h"

@implementation RondoPreferences

+(void)updateWithApp:(LeanplumApp *)app {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RondoPreferences *prefs = [self defaultPreferences];
    [realm transactionWithBlock:^{
        prefs.app = app;
    }];
}

+(void)updateWithEnv:(LeanplumEnv *)env {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RondoPreferences *prefs = [self defaultPreferences];
    [realm transactionWithBlock:^{
        prefs.env = env;
    }];
}

+(RondoPreferences *)defaultPreferences {
    RLMResults<RondoPreferences *> *results = [RondoPreferences allObjects];
    RondoPreferences *prefs = [results firstObject];
    if (!prefs) {
        prefs = [RondoPreferences new];
        prefs.id = 1;
        prefs.app = [LeanplumAppPersistence rondoQAProduction];
        prefs.env = [LeanplumEnvPersistence production];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:prefs];
        }];
    }
    return prefs;
}

+ (NSString *)primaryKey {
    return @"id";
}

@end
