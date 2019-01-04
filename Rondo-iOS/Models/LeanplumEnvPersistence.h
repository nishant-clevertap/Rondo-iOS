//
//  LeanplumEnvPersistence.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumEnv.h"

@interface LeanplumEnvPersistence : NSObject

+(void)saveLeanplumEnv:(LeanplumEnv *)env;
+(NSArray <LeanplumEnv *> *)loadLeanplumEnvs;

+(LeanplumEnv *)production;
+(LeanplumEnv *)productionSeed;

+(LeanplumEnv *)qa;
+(LeanplumEnv *)qaSeed;

+(void)seedDatabase;

@end
