//
//  VariablesViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "VariablesViewController.h"
#import <Leanplum/Leanplum.h>

@interface VariablesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *boolLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

DEFINE_VAR_STRING(varString, @"This is a local string.");
DEFINE_VAR_NUMBER(varNumber, 0);
DEFINE_VAR_BOOL(varBool, false);
DEFINE_VAR_FILE(varFile, nil);

@implementation VariablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateLabels];

    [Leanplum onVariablesChanged:^{
        [self updateLabels];
    }];

    [Leanplum forceContentUpdate];
}

-(void)updateLabels {
    self.stringLabel.text = varString.stringValue;
    self.numberLabel.text = [NSString stringWithFormat:@"%@", varNumber.numberValue];
    self.boolLabel.text = [NSString stringWithFormat:@"%@", varBool.numberValue];
    self.fileLabel.text = [NSString stringWithFormat:@"%@", varFile.stringValue];
    [self.imageView setImage:varFile.imageValue];
}

@end
