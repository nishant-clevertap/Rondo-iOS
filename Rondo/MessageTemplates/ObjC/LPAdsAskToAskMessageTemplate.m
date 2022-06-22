//
//  LPAdsAskToAskMessageTemplate.m
//  Leanplum-SDK_Example
//
//  Created by Nikola Zagorchev on 8.09.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import "LPAdsAskToAskMessageTemplate.h"
#import "LPMessageTemplateUtilities.h"
#import "LPAdsTrackingManager.h"
#import "Leanplum.h"
#import "LPActionContext.h"

@implementation LPAdsAskToAskMessageTemplate

+(void)defineAction
{
    NSString *name = @"Ads Pre-Permission";
    NSString *defaultMessage = @"If you would like to get ads tailored to your preferences, \
    you can enable this app to provide personalized ads on this app \
    and on partner apps.\nTap OK to enable personalized ads.";
    
    UIColor *defaultButtonTextColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    [Leanplum defineAction:name
                    ofKind:kLeanplumActionKindMessage | kLeanplumActionKindAction
             withArguments:@[
        [LPActionArg argNamed:LPMT_ARG_TITLE_TEXT withString:APP_NAME],
        [LPActionArg argNamed:LPMT_ARG_TITLE_COLOR
                    withColor:[UIColor blackColor]],
        [LPActionArg argNamed:LPMT_ARG_MESSAGE_TEXT
                   withString:defaultMessage],
        [LPActionArg argNamed:LPMT_ARG_MESSAGE_COLOR
                    withColor:[UIColor blackColor]],
        [LPActionArg argNamed:LPMT_ARG_BACKGROUND_IMAGE withFile:nil],
        [LPActionArg argNamed:LPMT_ARG_BACKGROUND_COLOR
                    withColor:[UIColor colorWithWhite:LIGHT_GRAY alpha:1.0]],
        [LPActionArg argNamed:LPMT_ARG_ACCEPT_BUTTON_TEXT
                   withString:LPMT_DEFAULT_OK_BUTTON_TEXT],
        [LPActionArg argNamed:LPMT_ARG_ACCEPT_BUTTON_BACKGROUND_COLOR
                    withColor:[UIColor colorWithWhite:LIGHT_GRAY alpha:1.0]],
        [LPActionArg argNamed:LPMT_ARG_ACCEPT_BUTTON_TEXT_COLOR
                    withColor:defaultButtonTextColor],
        [LPActionArg argNamed:LPMT_ARG_CANCEL_ACTION withAction:nil],
        [LPActionArg argNamed:LPMT_ARG_CANCEL_BUTTON_TEXT
                   withString:LPMT_DEFAULT_LATER_BUTTON_TEXT],
        [LPActionArg argNamed:LPMT_ARG_CANCEL_BUTTON_BACKGROUND_COLOR
                    withColor:[UIColor colorWithWhite:LIGHT_GRAY alpha:1.0]],
        [LPActionArg argNamed:LPMT_ARG_CANCEL_BUTTON_TEXT_COLOR
                    withColor:[UIColor grayColor]],
        [LPActionArg argNamed:LPMT_ARG_LAYOUT_WIDTH
                   withNumber:@(LPMT_DEFAULT_CENTER_POPUP_WIDTH)],
        [LPActionArg argNamed:LPMT_ARG_LAYOUT_HEIGHT
                   withNumber:@(LPMT_DEFAULT_CENTER_POPUP_HEIGHT)]
    ]
               withOptions:@{}
            presentHandler:^BOOL(LPActionContext * _Nonnull context) {
        if ([context hasMissingFiles]) {
            return NO;
        }
        
        @try {
            LPAdsAskToAskMessageTemplate *template = [[LPAdsAskToAskMessageTemplate alloc] init];
            template.context = context;
            if (@available(iOS 14, *)) {
                // If desired, the App settings can be opened if the status is declined
                if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
                    [template showPrePermissionMessage];
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

- (LPPopupViewController *)viewControllerWithContext:(LPActionContext *)context
{
    LPPopupViewController *viewController = [LPPopupViewController instantiateFromStoryboard];
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.context = context;
    viewController.shouldShowCancelButton = YES;
    viewController.acceptCompletionBlock = ^{
        [LPAdsTrackingManager showNativeAdsPrompt];
    };
    return viewController;
}

-(void)showPrePermissionMessage
{
    UIViewController *viewController = [self viewControllerWithContext:self.context];
    
    [LPMessageTemplateUtilities presentOverVisible:viewController];
}

@end
