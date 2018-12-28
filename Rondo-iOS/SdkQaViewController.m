//
//  ViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "SdkQaViewController.h"

@interface SdkQaViewController ()
@property (weak, nonatomic) IBOutlet UILabel *apiEndpointLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;

@end

@implementation SdkQaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)updateConfigLabels {
//    self.apiEndpointLabel.text = LPT_API_HOST_NAME;
//    self.sdkVersionLabel.text = LEANPLUM_SDK_VERSION;
}

@end
