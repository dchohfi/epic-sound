//
//  ESAppDelegate.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESAppDelegate.h"
#import "ESUserProfileViewController.h"
#import "SCUI.h"

@interface ESAppDelegate()

@property (nonatomic, strong) ESUserProfileViewController *loginViewController;

@end


@implementation ESAppDelegate

+ (void)initialize {
    [SCSoundCloud setClientID:kESClientId
                       secret:kESCLientSecret
                  redirectURL:kESRedirectURL];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.loginViewController = [[ESUserProfileViewController alloc] init];
    self.window.rootViewController = [self.loginViewController insideNavigationController];

    [self.window makeKeyAndVisible];
    return YES;
}
@end
