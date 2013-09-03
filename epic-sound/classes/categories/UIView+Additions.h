//
//  UIView+Additions.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/3/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
- (void) slideInAndThen: (void (^)(void))finishing;
@end
