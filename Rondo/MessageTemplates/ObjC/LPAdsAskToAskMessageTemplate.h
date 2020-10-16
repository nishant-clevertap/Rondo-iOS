//
//  LPAdsAskToAskMessageTemplate.h
//  Leanplum-SDK_Example
//
//  Created by Nikola Zagorchev on 8.09.20.
//  Copyright © 2020 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPMessageTemplateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAdsAskToAskMessageTemplate : NSObject <LPMessageTemplateProtocol>

+ (void)defineAction;
@property (nonatomic, strong) LPActionContext *context;

@end

NS_ASSUME_NONNULL_END
