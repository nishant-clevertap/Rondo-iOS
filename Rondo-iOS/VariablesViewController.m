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

DEFINE_VAR_STRING(var_text, @"This is a local string.");
DEFINE_VAR_NUMBER(var_number, 0);
DEFINE_VAR_BOOL(var_bool, false);
DEFINE_VAR_FILE(var_file, nil);

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
    self.stringLabel.text = var_text.stringValue;
    self.numberLabel.text = [NSString stringWithFormat:@"%@", var_number.numberValue];
    self.boolLabel.text = [NSString stringWithFormat:@"%@", var_bool.numberValue];
    self.fileLabel.text = [NSString stringWithFormat:@"%@", var_file.stringValue];
    [self.imageView setImage:var_file.imageValue];
}

@end
