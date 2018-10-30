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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LPLocationManager * LPLocation = [[LPLocationManager alloc] init];
    if(LPLocation.needsAuthorization){
        [LPLocation authorize];
    }
    [Leanplum start];
}


@end
