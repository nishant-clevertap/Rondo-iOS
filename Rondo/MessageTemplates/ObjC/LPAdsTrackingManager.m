//
//  LPAdsTrackingManager.m
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 23.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "Leanplum.h"
#import "LPAdsTrackingManager.h"

@implementation LPAdsTrackingManager

+ (NSString *)advertisingIdentifierString
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (BOOL)isAdvertisingTrackingEnabled
{
    if (@available(iOS 14, *)) {
        return [ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized;
    }
    
    if (@available(iOS 10, *)) {
        return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    
    return NO;
}

+ (void)showNativeAdsPrompt
{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusAuthorized: {
                    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                    NSLog(@"Authorized. Advertising ID is: %@. Use setDeviceId to set idfa now.", idfa);
                    [Leanplum setDeviceId:idfa];
                    break;
                }
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"NotDetermined");
                    break;
                    
                case ATTrackingManagerAuthorizationStatusRestricted:
                    NSLog(@"Restricted");
                    break;
                    
                case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"Denied");
                    break;
                    
                default:
                    NSLog(@"Unknown");
                    break;
            }
        }];
    }
}

@end
