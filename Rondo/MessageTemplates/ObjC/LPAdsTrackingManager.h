//
//  LPAdsTrackingManager.h
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 23.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPAdsTrackingManager : NSObject

+ (NSString *)advertisingIdentifierString;
+ (BOOL)isAdvertisingTrackingEnabled;
+ (void)showNativeAdsPrompt;

@end

NS_ASSUME_NONNULL_END
