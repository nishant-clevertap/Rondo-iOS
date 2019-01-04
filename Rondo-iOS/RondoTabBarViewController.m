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
#import "RondoPreferences.h"
#import "LeanplumAppPersistence.h"
#import "LeanplumEnvPersistence.h"

@interface RondoTabBarViewController ()

@end

@interface Leanplum(Socket)

+ (void)setSocketHostName:(NSString *)hostName withPortNumber:(int)port;

@end

@implementation RondoTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self seedDatabases];

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

    [Leanplum setApiHostName:env.apiHostName withServletName:@"api" usingSsl:env.apiSSL];
    [Leanplum setSocketHostName:env.socketHostName withPortNumber:env.socketPort];

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
    RondoPreferences *prefs = [RondoPreferences defaultPreferences];
    RondoState *rondoState = [RondoState sharedState];

    rondoState.app = prefs.app;
    rondoState.env = prefs.env;
    rondoState.sdkVersion = [self SDKVersionFromPodfile];
}

-(void)seedDatabases {
    [LeanplumAppPersistence seedDatabase];
    [LeanplumEnvPersistence seedDatabase];
}

-(NSString *)SDKVersionFromPodfile {
    NSError *error;
    NSString *strFileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                   pathForResource: @"Podfile" ofType: @""] encoding:NSUTF8StringEncoding error:&error];
    if(error) {  //Handle error
    }

    NSArray <NSString *> * components = [strFileContent componentsSeparatedByString:@"pod 'Leanplum-iOS-SDK', "];
    NSArray <NSString *> * components2 = [components[1] componentsSeparatedByString:@"\n"];
    NSString *sdkVersion = components2[0];
    return sdkVersion;
}

@end
