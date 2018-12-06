//
//  ViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "ViewController.h"
#import <Leanplum/Leanplum.h>
#import <LeanplumLocation/LPLocationManager.h>
#import "Configure.h"
//#import <Leanplum/Constants.h>
#import "UIDevice+IdentifierAddition.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *apiEndpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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


    [Leanplum startWithUserId:@"A694K4"];
    [Leanplum onStartResponse:^(BOOL success) {
    }];
    [Leanplum onMessageDisplayed:^(LPMessageArchiveData *messageArchiveData) {
        NSLog(messageArchiveData.messageID);
        NSLog(messageArchiveData.messageBody);
        NSLog(messageArchiveData.recipientUserID);
//        NSLog(messageArchiveData.deliveryDateTime);
    }];
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *deviceId2 = [[UIDevice currentDevice] leanplum_uniqueGlobalDeviceIdentifier];

}

-(void)updateConfigLabels {
    self.apiEndpointLabel.text = LPT_API_HOST_NAME;
//    self.sdkVersionLabel.text = LEANPLUM_SDK_VERSION;
}

@end
