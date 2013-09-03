//
//  UIView+Additions.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/3/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)
- (void) slideInAndThen: (void (^)(void))finishing{
    CGRect originalRect = self.frame;
    self.frame = CGRectMake(999, originalRect.origin.y, originalRect.size.width, originalRect.size.height);
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = originalRect;
    } completion:^(BOOL finished) {
        if(finished && finishing){
            finishing();
        }
    }];
}
@end
