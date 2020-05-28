//
//  LPExceptionCatcher.m
//  Rondo-iOS
//
//  Created by Milos Jakovljevic on 29/05/2020.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import "LPExceptionCatcher.h"

@implementation LPExceptionCatcher

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
