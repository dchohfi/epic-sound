//
//  ESUserController.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUser.h"
#import "ESTrack.h"

typedef void(^ESUserDataSuccessBlock)(ESUser *user);
typedef void(^ESUserLikesSuccessBlock)(NSArray *likes);
typedef void(^ESUserControllerFailBlock)(NSError *error);

@interface ESUserController : NSObject

+ (ESUserController *) userController;

- (void) getUserData: (ESUserDataSuccessBlock) successBlock
             failure: (ESUserControllerFailBlock) failBlock;

- (void) getUserLikes: (ESUserLikesSuccessBlock) successBlock
              failure: (ESUserControllerFailBlock) failBlock;

@end
