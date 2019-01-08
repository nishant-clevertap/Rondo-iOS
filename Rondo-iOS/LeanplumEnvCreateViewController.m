//
//  LeanplumEnvCreateViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumEnvCreateViewController.h"
#import "LeanplumEnv.h"
#import "LeanplumEnvPersistence.h"

@interface LeanplumEnvCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *apiHostname;
@property (weak, nonatomic) IBOutlet UISwitch *apiSSL;
@property (weak, nonatomic) IBOutlet UITextField *socketHostname;
@property (weak, nonatomic) IBOutlet UITextField *socketPort;

@end

@implementation LeanplumEnvCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Env";
}

- (IBAction)createButtonPressed:(id)sender {
    [LeanplumEnvPersistence saveLeanplumEnv:[self createdEnv]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(LeanplumEnv *)createdEnv {
    LeanplumEnv *env = [[LeanplumEnv alloc] init];
    env.apiHostName = self.apiHostname.text;
    env.apiSSL = self.apiSSL.isEnabled;
    env.socketHostName = self.socketHostname.text;
    env.socketPort = self.socketPort.text.intValue;
    return env;
}

@end
