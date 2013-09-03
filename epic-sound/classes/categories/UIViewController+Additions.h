//
//  UIViewController+Additions.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)
- (UINavigationController *) insideNavigationController;
- (UIActivityIndicatorView *) loading;
- (UIBarButtonItem *) reloadButtonForTarget: (id) target
                                andSelector: (SEL) selector;
- (UIBarButtonItem *) loadingButton;
@end
