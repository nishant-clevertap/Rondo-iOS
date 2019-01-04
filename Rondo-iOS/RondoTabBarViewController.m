//
//  RondoTabBarViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "RondoTabBarViewController.h"
#import <Leanplum/Leanplum.h>
#import <LeanplumLocation/LPLocationManager.h>
#import "Configure.h"
//#import <Leanplum/Constants.h>

@interface RondoTabBarViewController ()

@end

@implementation RondoTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LPLocationManager * LPLocation = [[LPLocationManager alloc] init];
    //    if(LPLocation.needsAuthorization){
    [LPLocation authorize];
    //    }

    CLLocationManager *locManager = [[CLLocationManager alloc]init];
    //    self.locManager.delegate = self;
    [locManager requestAlwaysAuthorization];
    //    [self updateConfigLabels];
#ifdef DEBUG
    LEANPLUM_USE_ADVERTISING_ID;
    [Leanplum setAppId:LPT_APP_ID withDevelopmentKey:LPT_DEVELOPMENT_KEY];
#else
    [Leanplum setAppId:LPT_APP_ID withProductionKey:LPT_PRODUCTION_KEY];
#endif

    [Leanplum onStartResponse:^(BOOL success) {
    }];

    [Leanplum start];
}

@end
