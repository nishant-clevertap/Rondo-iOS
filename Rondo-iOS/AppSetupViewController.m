//
//  AppSetupViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AppSetupViewController.h"
#import <Leanplum/Leanplum.h>
#import "RondoState.h"
#import "LeanplumApp.h"
#import "LeanplumEnv.h"
#import "CopyLabel.h"
#import <UserNotifications/UserNotifications.h>
#import "RondoProductionMode.h"

@interface AppSetupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *devKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodKeyLabel;

@property (weak, nonatomic) IBOutlet CopyLabel *userIdLabel;
@property (weak, nonatomic) IBOutlet CopyLabel *deviceIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiSslLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketPortLabel;
@property (weak, nonatomic) IBOutlet UISwitch *productionMode;

@end

@implementation AppSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Setup";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self populateInfo];
}

-(void)populateInfo {
    RondoState *state = [RondoState sharedState];
    LeanplumApp *app = state.app;
    LeanplumEnv *env = state.env;

    self.appNameLabel.text = app.displayName;
    self.appIdLabel.text = app.appId;
    self.devKeyLabel.text = app.devKey;
    self.prodKeyLabel.text = app.prodKey;

    self.sdkVersionLabel.text = state.sdkVersion;
    self.apiHostLabel.text = env.apiHostName;
    self.apiSslLabel.text = env.apiSSL ? @"True" : @"False";
    self.socketHostLabel.text = env.socketHostName;
    self.socketPortLabel.text = [NSString stringWithFormat:@"%i", env.socketPort];

    self.userIdLabel.text = Leanplum.userId;
    self.deviceIdLabel.text = Leanplum.deviceId;

    self.productionMode.on = [RondoProductionMode productionMode];
}

- (IBAction)leanplumStartPressed:(id)sender {
    [Leanplum start];
}

- (IBAction)requestPushPermissions:(id)sender {
    [self registerForRemoteNotifications];
}

- (void)registerForRemoteNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}
- (IBAction)changeProductionMode:(id)sender {
    [RondoProductionMode setProductionMode:self.productionMode.on];
}

@end
