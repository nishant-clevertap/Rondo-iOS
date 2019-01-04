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
#import "RondoState.h"
#import "LeanplumApp.h"
#import "LeanplumEnv.h"
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

    [self setupInitialAppState];


    RondoState *rondoState = [RondoState sharedState];
    LeanplumApp *app = rondoState.app;
    LeanplumEnv *env = rondoState.env;
#ifdef DEBUG
    LEANPLUM_USE_ADVERTISING_ID;
    [Leanplum setAppId:app.appId withDevelopmentKey:app.devKey];
#else
    [Leanplum setAppId:app.appId withProductionKey:app.prodKey];
#endif

    [Leanplum onStartResponse:^(BOOL success) {
    }];

    [Leanplum start];
}

-(void)setupInitialAppState {

    LeanplumApp *app = [LeanplumApp new];
    app.displayName = @"Rondo QA";
    app.appId = @"app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs";
    app.devKey = @"dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0";
    app.prodKey = @"prod_D5ECYBLrRrrOYaFZvAFFHTg1JyZ2Llixe5s077Lw3rM";

    LeanplumEnv *env = [LeanplumEnv new];
    env.apiHostName = @"api.leanplum.com";
    env.apiSSL = YES;
    env.socketHostName = @"dev.leanplum.com";
    env.socketPort = 443;

    RondoState *rondoState = [RondoState sharedState];
    rondoState.app = app;
    rondoState.env = env;
}

@end
