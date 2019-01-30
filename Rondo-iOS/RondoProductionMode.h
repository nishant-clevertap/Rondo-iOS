//
//  RondoProductionMode.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/30/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RondoProductionMode : NSObject

+(BOOL)productionMode;
+(void)setProductionMode:(BOOL)productionMode;

@end

NS_ASSUME_NONNULL_END
