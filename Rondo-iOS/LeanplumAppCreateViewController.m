//
//  LeanplumAppCreateViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumAppCreateViewController.h"
#import "LeanplumApp.h"
#import "LeanplumAppPersistence.h"

@interface LeanplumAppCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *devKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *prodKeyTextField;

@end

@implementation LeanplumAppCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)createButtonPressed:(id)sender {
    [LeanplumAppPersistence saveLeanplumApp:[self createdApp]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(LeanplumApp *)createdApp {
    LeanplumApp *app = [[LeanplumApp alloc] init];
    app.displayName = self.displayNameTextField.text;
    app.appId = self.appIdTextField.text;
    app.devKey = self.devKeyTextField.text;
    app.prodKey = self.prodKeyTextField.text;
    return app;
}

@end
