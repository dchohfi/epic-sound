//
//  ESUserController.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESUserController.h"
#import "SCAPI.h"
#import "JSONKit.h"

@implementation ESUserController

+ (ESUserController *) userController {
    static ESUserController *singletonInstance = nil;
    
    if(singletonInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singletonInstance = [[ESUserController alloc] init];
        });
    }
    return singletonInstance;
}
- (void) getUserData: (ESUserDataSuccessBlock) successBlock
             failure: (ESUserControllerFailBlock) failBlock {   
    NSString *meUrl = @"https://api.soundcloud.com/me.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:meUrl]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(error){
                         failBlock(error);
                         return;
                     }
                     JSONDecoder *decoder = [JSONDecoder decoder];
                     NSError *jsonError;
                     NSDictionary *userInfo = [decoder objectWithData:responseData error:&jsonError];
                     if(!jsonError){
                         ESUser *user = [ESUser userWithData:userInfo];
                             successBlock(user);
                         return;
                     }
                     failBlock(jsonError);
                 });
             }];
}
- (void) getUserLikes: (ESUserLikesSuccessBlock) successBlock
              failure: (ESUserControllerFailBlock) failBlock {
    NSString *likesUrl = @"https://api.soundcloud.com/me/favorites.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:likesUrl]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(error){
                         failBlock(error);
                         return;
                     }
                     JSONDecoder *decoder = [JSONDecoder decoder];
                     NSError *jsonError;
                     NSArray *tracksInfo = [decoder objectWithData:responseData error:&jsonError];
                     if(!jsonError){
                         NSArray *tracks = [ESTrack tracksWithData:tracksInfo];
                         
                            successBlock(tracks);
                         return;
                     }
                     failBlock(jsonError);
                 });
             }];
}
@end
