//
//  RondoProductionMode.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/30/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "RondoProductionMode.h"

#define RONDO_PRODUCTION_MODE_KEY @"RONDO_PRODUCTION_MODE_KEY"

@implementation RondoProductionMode

+(BOOL)productionMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:RONDO_PRODUCTION_MODE_KEY];
}

+(void)setProductionMode:(BOOL)productionMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:productionMode forKey:RONDO_PRODUCTION_MODE_KEY];
    [defaults synchronize];
}

@end
