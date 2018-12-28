//
//  AppSetupViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AppSetupViewController.h"
#import <Leanplum/Leanplum.h>

@interface AppSetupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *devKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiSslLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketPortLabel;

@end

@implementation AppSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)leanplumStartPressed:(id)sender {
    [Leanplum start];
}

@end
