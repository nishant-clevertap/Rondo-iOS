//
//  ViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "SdkQaViewController.h"
#import "RondoState.h"
#import "LeanplumApp.h"
#import "LeanplumEnv.h"

@interface SdkQaViewController ()
@property (weak, nonatomic) IBOutlet UILabel *apiEndpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leanplumAppLabel;

@end

@implementation SdkQaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateConfigLabels];
    self.title = @"SDK QA";
}

-(void)updateConfigLabels {
    RondoState *rondoState = [RondoState sharedState];
    LeanplumApp *app = rondoState.app;
    LeanplumEnv *env = rondoState.env;

    self.sdkVersionLabel.text = @"";
    self.apiEndpointLabel.text = env.apiHostName;
    self.leanplumAppLabel.text = app.displayName;

}

@end
