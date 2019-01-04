//
//  RondoPreferences.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Realm/Realm.h>
#import "LeanplumApp.h"
#import "LeanplumEnv.h"

@interface RondoPreferences : RLMObject

@property NSInteger id;
@property (nonatomic, strong) LeanplumApp *app;
@property (nonatomic, strong) LeanplumEnv *env;

+(void)updateWithApp:(LeanplumApp *)app;
+(void)updateWithEnv:(LeanplumEnv *)env;
+(RondoPreferences *)defaultPreferences;

@end
