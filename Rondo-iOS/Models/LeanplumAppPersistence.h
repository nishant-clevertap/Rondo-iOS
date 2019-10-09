//
//  LeanplumAppPersistence.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanplumApp.h"

@interface LeanplumAppPersistence : NSObject

+(void)saveLeanplumApp:(LeanplumApp *)app;
+(NSArray <LeanplumApp *> *)loadLeanplumApps;
+(void)seedDatabase;

+(LeanplumApp *)rondoQAProduction;
+(LeanplumApp *)rondoQAProductionSeed;

+(LeanplumApp *)musalaQA;
+(LeanplumApp *)musalaQASeed;

@end
