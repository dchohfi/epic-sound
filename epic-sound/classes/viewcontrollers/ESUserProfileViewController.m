//
//  ESUserProfileViewController.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESUserProfileViewController.h"
#import "ESUserController.h"
#import "SCUI.h"
#import "ESTrackCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIImageView+WebCache.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
@interface ESUserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@property (weak, nonatomic) IBOutlet UIView *viewUserData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelFullName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelStatsCouting;

@property (nonatomic, strong) ESUser *loggedUser;
@property (nonatomic, strong) NSArray *likes;

@end

@implementation ESUserProfileViewController

- (void)viewDidLoad {
    if([self isLogged]){
        [self configureViewForLoggedState];
    }else{
        [self configureViewForLoginState];
    }
    [ESTrackCell registerCellOnTableView:self.tableView];
    [self addEasterEgg];
}
- (IBAction)login:(id)sender {
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"need_login", nil)
                                                                message:NSLocalizedString(@"must_be_logged", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        } else if (error) {
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         [self showErrorView:error];
                                     }];
        } else {
            [self configureViewForLoggedState];
        }
    };
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *soundCloudLogin = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                                         completionHandler:handler];
        
        [self presentViewController:soundCloudLogin animated:YES completion:nil];
    }];
}
#pragma mark - UITableView methods
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"likes", nil);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likes.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESTrackCell *cell = [ESTrackCell dequeueCellInTableView:tableView];
    ESTrack *track = self.likes[indexPath.row];
    [cell setTrack:track];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ESTrack *track = self.likes[indexPath.row];
    [self openTrack: track];
}
#pragma mark - private methods
- (void) animateLabels {
    NSArray *labels = @[self.labelFullName, self.labelStatsCouting, self.labelUserPlace ];
    for (UILabel *label in labels) {
        label.hidden = YES;
    }
    [self.labelFullName slideInAndThen:^{
        [self.labelUserPlace slideInAndThen:^{
            [self.labelStatsCouting slideInAndThen:nil];
        }];
    }];
}
- (void) changeAndAnimateAvatar {
    self.imageUserAvatar.alpha = 0.0;
    [self.imageUserAvatar setImageWithURL:self.loggedUser.avatarUrl
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(image){
            [UIView animateWithDuration:0.5 animations:^{
                self.imageUserAvatar.alpha = 1.0;
            }];
        }
    }];
}
- (void) openTrack: (ESTrack *) track {
    if([[UIApplication sharedApplication] canOpenURL:track.soundCloudURL]){
        [[UIApplication sharedApplication] openURL:track.soundCloudURL];
    }else {
        [[UIApplication sharedApplication] openURL:track.permalinkUrl];
    }
}
- (void) configureViewForLoggedState {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"logout", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(logout)];
    [self setLoginViewsHidden:YES];
    [self setLoggedViewsHidden:NO];
    
    [self loadUserData];
}
- (void) showErrorView: (NSError *) error {
    WBErrorNoticeView *errorView = [WBErrorNoticeView errorNoticeInView:self.view
                                                                  title:NSLocalizedString(@"error", nil)
                                                                message:[error localizedDescription]];
    [errorView show];
}
- (void) configureViewForLoginState {
    self.navigationItem.title = NSLocalizedString(@"epic_sound", nil);
    [self setLoginViewsHidden:NO];
    [self setLoggedViewsHidden:YES];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void) setLoggedViewsHidden: (BOOL) hidden {
    NSArray *loginViews = @[self.viewUserData, self.tableView];
    for (UIView *view in loginViews) {
        [view setHidden:hidden];
    }
}
- (void) setLoginViewsHidden: (BOOL) hidden {
    NSArray *loggedViews = @[self.buttonLogin];
    for (UIView *view in loggedViews) {
        [view setHidden:hidden];
    }
}
- (void) logout {
    self.loggedUser = nil;
    self.likes = nil;
    [SCSoundCloud removeAccess];
    [self configureViewForLoginState];
}
- (BOOL) isLogged {
    return [SCSoundCloud account] != nil;
}
- (void) loadUserData {
    self.navigationItem.rightBarButtonItem = [self loadingButton];
    self.navigationItem.title = NSLocalizedString(@"loading", nil);
    [[ESUserController userController] getUserData:^(ESUser *user) {
        [self.tableView addPullToRefreshWithActionHandler:^{
            [self loadUserLikes];
        }];
        self.navigationItem.rightBarButtonItem = nil;
        self.loggedUser = user;
    } failure:^(NSError *error) {
        [self showErrorView: error];
        self.navigationItem.rightBarButtonItem = [self reloadButtonForTarget:self
                                                                 andSelector:@selector(loadUserData)];
    }];
}
- (void) loadUserLikes {
    [[ESUserController userController] getUserLikes:^(NSArray *likes) {
        self.likes = likes;
    } failure:^(NSError *error) {
        [self showErrorView:error];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}
- (void) addEasterEgg {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(hireDiego)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.navigationController.navigationBar addGestureRecognizer:swipe];
}
- (void) hireDiego {
    WBSuccessNoticeView *success = [WBSuccessNoticeView successNoticeInView:self.view
                                                                      title:@"Diego ➕ SoundCloud = 👍🎈🇩🇪❤️"];
    success.slidingMode = WBNoticeViewSlidingModeUp;
    [success show];
}

#pragma mark - custom getter/setter
- (void)setLoggedUser:(ESUser *)loggedUser {
    _loggedUser = loggedUser;
    self.navigationItem.title = loggedUser.username;
    if(loggedUser){
        [self.tableView triggerPullToRefresh];
        NSString *followersFollowing = NSLocalizedString(@"followers_following", nil);
        followersFollowing = [followersFollowing stringByReplacingOccurrencesOfString:@"%followers%"
                                                                           withString:[NSString stringWithFormat:@"%i", loggedUser.followersCount]];
        followersFollowing = [followersFollowing stringByReplacingOccurrencesOfString:@"%following%"
                                                                           withString:[NSString stringWithFormat:@"%i", loggedUser.followingsCount]];
        self.labelStatsCouting.text = followersFollowing;
        self.labelUserPlace.text = [NSString stringWithFormat:@"%@ - %@", loggedUser.country, loggedUser.city];
        self.labelFullName.text = loggedUser.fullName;
        [self changeAndAnimateAvatar];
        [self animateLabels];
    }else {
        self.imageUserAvatar.image = nil;
        self.labelStatsCouting.text = @"";
        self.labelUserPlace.text = @"";
        self.labelFullName.text = @"";
    }
}
- (void)setLikes:(NSArray *)likes {
    _likes = likes;
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView reloadData];
}

@end
