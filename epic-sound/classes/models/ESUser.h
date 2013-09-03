//
//  ESUser.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESUser : NSObject

@property (nonatomic) int userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) int followersCount;
@property (nonatomic) int followingsCount;

+ (ESUser *) userWithData: (NSDictionary *) data;

@end
