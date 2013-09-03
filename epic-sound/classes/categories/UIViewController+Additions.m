//
//  UIViewController+Additions.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (UINavigationController *) insideNavigationController {
    return [[UINavigationController alloc] initWithRootViewController:self];
}
- (UIBarButtonItem *) reloadButtonForTarget: (id) target
                                andSelector: (SEL) selector {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo
                                                         target:target
                                                         action:selector];
}
- (UIBarButtonItem *) loadingButton {
    return [[UIBarButtonItem alloc] initWithCustomView:[self loading]];
}
- (UIActivityIndicatorView *) loading {
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loading startAnimating];
    [loading setHidesWhenStopped:YES];
    return loading;
}

@end
