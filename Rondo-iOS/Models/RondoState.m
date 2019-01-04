//
//  InternalState.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "RondoState.h"

static RondoState *leanplum_sharedInternalState = nil;
static dispatch_once_t leanplum_InternalState_onceToken;

@implementation RondoState

+ (RondoState *)sharedState
{
    dispatch_once(&leanplum_InternalState_onceToken, ^{
        leanplum_sharedInternalState = [[self alloc] init];
    });
    return leanplum_sharedInternalState;
}

@end
