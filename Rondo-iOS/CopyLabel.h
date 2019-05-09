//
//  CopyLabel.h
//  Rondo-iOS
//
//  Created by Nathan Fair on 5/9/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CopyLabel : UILabel {
    SEL copyAction;
    id copyTarget;
}
- (void)setTarget:(id)target forCopyAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
