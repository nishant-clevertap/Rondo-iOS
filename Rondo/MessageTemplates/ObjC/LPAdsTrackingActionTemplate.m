//
//  LPAdsTrackingActionTemplate.m
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 2.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import "LPAdsTrackingActionTemplate.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation LPAdsTrackingActionTemplate

+ (void)defineAction {
    NSString *name = @"Register for Ads Tracking";
    
    [Leanplum defineAction:name
                    ofKind:kLeanplumActionKindAction
             withArguments:@[]
             withResponder:^BOOL(LPActionContext *context) {
        @try {
            if (@available(iOS 14, *)) {
                if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
                    [self showNativeAdsPrompt];
                    return YES;
                }
                // Open the App Settings if the user has already declined tracking
                if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusDenied) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    return YES;
                }
            }
            return NO;
        } @catch (NSException *exception) {
            NSLog(@"%@: %@\n%@", name, exception, [exception callStackSymbols]);
            return NO;
        }
    }];
}

+(void)showNativeAdsPrompt
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
