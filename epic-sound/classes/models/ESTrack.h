//
//  ESTrack.h
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESUser;

@interface ESTrack : NSObject

@property (nonatomic) int trackId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) ESUser *user;
@property (nonatomic, strong) NSURL *permalinkUrl;
@property (nonatomic, strong) NSURL *waveformUrl;
@property (nonatomic, strong) NSURL *artworkUrl;
@property (nonatomic, strong) NSString *timeIntervalSinceCreatedAt;
@property (nonatomic) int playbackCount;
@property (nonatomic) int commentCount;
@property (nonatomic) int favoritingsCount;
@property (nonatomic, readonly) NSURL *soundCloudURL;
@property (nonatomic, strong) UIImage *halfWaveImage;

+ (ESTrack *) trackWithData: (NSDictionary *) data;
+ (NSArray *) tracksWithData: (NSArray *) data;

@end
