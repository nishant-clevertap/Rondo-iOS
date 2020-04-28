//
//  LeanplumAppPersistence.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumAppPersistence.h"
#import <Realm/Realm.h>

@implementation LeanplumAppPersistence

+(void)saveLeanplumApp:(LeanplumApp *)app {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:app];
    }];
}

+(NSArray <LeanplumApp *> *)loadLeanplumApps {
    RLMResults<LeanplumApp *> *results = [LeanplumApp allObjects];
    NSMutableArray <LeanplumApp *> *apps = [NSMutableArray arrayWithCapacity:results.count];
    for (int i=0;i<results.count;i++) {
        LeanplumApp *app = [results objectAtIndex:i];
        [apps addObject:app];
    }
    return apps;
}

+(void)seedDatabase {
    if (![self rondoQAProduction]) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:[self rondoQAProductionSeed]];
            [realm addObject:[self rondoQAAutomationSeed]];
            [realm addObject:[self musalaQASeed]];
        }];
    }
}

+(LeanplumApp *)rondoQAProduction {
    RLMResults<LeanplumApp *> *results = [LeanplumApp objectsWhere:@"displayName = 'Rondo QA Production'"];
    return results.firstObject;
}

+(LeanplumApp *)rondoQAProductionSeed {
    LeanplumApp *app = [LeanplumApp new];
    app.displayName = @"Rondo QA Production";
    app.appId = @"app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs";
    app.devKey = @"dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0";
    app.prodKey = @"prod_D5ECYBLrRrrOYaFZvAFFHTg1JyZ2Llixe5s077Lw3rM";
    return app;
}

+(LeanplumApp *)musalaQA {
    RLMResults<LeanplumApp *> *results = [LeanplumApp objectsWhere:@"displayName = 'Musala QA'"];
    return results.firstObject;
}

+(LeanplumApp *)musalaQASeed {
    LeanplumApp *app = [LeanplumApp new];
    app.displayName = @"Musala QA";
    app.appId = @"app_qA781mPlJYjzlZLDlTh68cdNDUOf31kcTg1TCbSXSS0";
    app.devKey = @"dev_WqNqX0qOOHyTEQtwKXs5ldhqErHfixvcSAMlYgyIL0U";
    app.prodKey = @"prod_kInQHXLJ0Dju7QJRocsD5DYMdYAVbdGGwhl6doTfH0k";
    return app;
}

+(LeanplumApp *)rondoQAAutomation {
    RLMResults<LeanplumApp *> *results = [LeanplumApp objectsWhere:@"displayName = 'Rondo QA Automation'"];
    return results.firstObject;
}

+(LeanplumApp *)rondoQAAutomationSeed {
    LeanplumApp *app = [LeanplumApp new];
    app.displayName = @"Rondo QA Automation";
    app.appId = @"app_UQcFGVeXzOCVsovrlUebad9R67hFJqzDegfQPZRnVZM";
    app.devKey = @"dev_b9qX0tcazL5PCQFuZ7pxsfT6XHA7xQkaFtYVrgt4Kq0";
    app.prodKey = @"prod_lL8RSFzmHy0iVYXQpzjUVEHDlaUz5idT0H7BVs6Bn1Q";
    return app;
}


@end
