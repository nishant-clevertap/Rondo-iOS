//
//  LeanplumApp.h
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeanplumApp : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *devKey;
@property (nonatomic, strong) NSString *prodKey;

@end
