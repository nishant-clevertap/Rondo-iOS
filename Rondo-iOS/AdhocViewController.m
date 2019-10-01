//
//  AdhocViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AdhocViewController.h"
#import <Leanplum/Leanplum.h>

#define ADHOC_VIEW_CONTROLLER_PERSIST_TRACK_KEY @"ADHOC_VIEW_CONTROLLER_PERSIST_TRACK_KEY"
#define ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_KEY_KEY @"ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_KEY_KEY"
#define ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_VALUE_KEY @"ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_VALUE_KEY"
#define ADHOC_VIEW_CONTROLLER_PERSIST_STATE_KEY @"ADHOC_VIEW_CONTROLLER_PERSIST_STATE_KEY"

@interface AdhocViewController ()
@property (weak, nonatomic) IBOutlet UITextField *trackTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAttribTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAttribValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *forceContentUpdateButton;

@end

@implementation AdhocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Adhoc";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    self.trackTextField.text = [self retrieveLastUsedTrackString];
    self.stateTextField.text = [self retrieveLastUsedStateString];
    self.eventKeyTextField.text = [self retrieveLastUsedParameterKey];
    self.eventValueTextField.text = [self retrieveLastUsedParameterValue];
    self.forceContentUpdateButton.layer.borderWidth = 2.0f;
    self.forceContentUpdateButton.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)tap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)sendTrack:(id)sender {
    if (self.eventValueTextField && self.eventKeyTextField) {
        [Leanplum track:self.trackTextField.text withParameters:@{self.eventKeyTextField.text : self.eventValueTextField.text}];
    } else {
        [Leanplum track:self.trackTextField.text];
    }
    [self persistLastUsedTrackString: self.trackTextField.text];
    [self persistLastUsedParameterKey: self.eventKeyTextField.text];
    [self persistLastUsedParameterValue: self.eventValueTextField.text];
}

- (IBAction)sendState:(id)sender {
    [Leanplum advanceTo:self.stateTextField.text];
    [self persistLastUsedStateString:self.stateTextField.text];
}

- (IBAction)setUserAttrib:(id)sender {
    [Leanplum setUserAttributes:
  @{
    self.userAttribTextField.text : self.userAttribValueTextField.text
    }];
}

- (IBAction)setUserId:(NSString *)userId {
    [Leanplum setUserId:userId];
}

- (IBAction)forceContentUpdate {
    [Leanplum forceContentUpdate];
}

-(void)persistLastUsedTrackString:(NSString *)track {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:track forKey:ADHOC_VIEW_CONTROLLER_PERSIST_TRACK_KEY];
    [userDefaults synchronize];
}

-(NSString *)retrieveLastUsedTrackString {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:ADHOC_VIEW_CONTROLLER_PERSIST_TRACK_KEY];
}

-(void)persistLastUsedParameterKey:(NSString *)track {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:track forKey:ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_KEY_KEY];
    [userDefaults synchronize];
}

-(NSString *)retrieveLastUsedParameterKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_KEY_KEY];
}

-(void)persistLastUsedParameterValue:(NSString *)track {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:track forKey:ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_VALUE_KEY];
    [userDefaults synchronize];
}

-(NSString *)retrieveLastUsedParameterValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:ADHOC_VIEW_CONTROLLER_PERSIST_PARAM_VALUE_KEY];
}

-(void)persistLastUsedStateString:(NSString *)state {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:state forKey:ADHOC_VIEW_CONTROLLER_PERSIST_STATE_KEY];
    [userDefaults synchronize];
}

-(NSString *)retrieveLastUsedStateString {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:ADHOC_VIEW_CONTROLLER_PERSIST_STATE_KEY];
}

@end
