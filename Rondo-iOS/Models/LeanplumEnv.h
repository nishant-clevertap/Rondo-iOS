//
//  LeanplumEnv.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeanplumEnv : NSObject

@property (nonatomic, strong) NSString *apiHostName;
@property (nonatomic, assign) BOOL apiSSL;
@property (nonatomic, strong) NSString *socketHostName;
@property (nonatomic, assign) int socketPort;

@end
