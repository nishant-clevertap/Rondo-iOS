//
//  LPAdsTrackingActionTemplate.m
//  Rondo-iOS
//
//  Created by Nikola Zagorchev on 2.10.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import "LPAdsTrackingActionTemplate.h"
#import "LPAdsTrackingManager.h"

@implementation LPAdsTrackingActionTemplate

+ (void)defineAction
{
    NSString *name = @"Register for Ads Tracking";
    
    [Leanplum defineAction:name
                    ofKind:kLeanplumActionKindAction
             withArguments:@[]
               withOptions:@{} presentHandler:^BOOL(LPActionContext * _Nonnull context) {
        @try {
            if (@available(iOS 14, *)) {
                if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
                    [LPAdsTrackingManager showNativeAdsPrompt];
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
    } dismissHandler:^BOOL(LPActionContext * _Nonnull context) {
        return NO;
    }];
}

@end
