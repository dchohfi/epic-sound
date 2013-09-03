//
//  ESTrackParserTest.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESTrackParserTest.h"
#import "ESTrack.h"
#import "ESUser.h"
@interface ESTrackParserTest()

@property (nonatomic, strong) NSDictionary *trackJson;

@end

@implementation ESTrackParserTest

- (void)setUp {
    [super setUp];
    NSString *jsonPath = [[NSBundle bundleForClass: [self class]] pathForResource:@"track" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    self.trackJson = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers error:nil];
}

- (void) testShouldBeAbleToParseValidJson {
    ESTrack *track = [ESTrack trackWithData:self.trackJson];
    STAssertEquals(13158665, track.trackId, @"Should be able to parse the trackid correctly");
    STAssertEqualObjects(@"Munching at Tiannas house", track.title, @"Should be able to parse the title correctly");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss ZZZ";
    NSDate *trackDate = [dateFormatter dateFromString:@"2011/04/06 15:37:43 +0000"];
    STAssertEqualObjects(trackDate, track.createdAt, @"Should be able to parse the createdAt value correctly");
    STAssertEqualObjects([NSURL URLWithString:@"http://soundcloud.com/user2835985/munching-at-tiannas-house"], track.permalinkUrl, @"Should be able to parse permalink_url correctly");
    STAssertEqualObjects([NSURL URLWithString:@"http://w1.sndcdn.com/fxguEjG4ax6B_m.png"], track.waveformUrl, @"Should be able to parse waveform_url correctly");
    STAssertEqualObjects([NSURL URLWithString:@"http://a1.sndcdn.com/images/default_avatar_large.png?142a848"], track.artworkUrl, @"Shoulg get avatar from user when no artwork on track");
    STAssertEqualObjects([NSURL URLWithString:@"soundcloud://tracks:13158665"], track.soundCloudURL, @"Should be able to create soundCloudUrl correcly");
    STAssertEquals(0, track.favoritingsCount, @"Should be able to parse favoritings_count");
    STAssertEquals(0, track.playbackCount, @"Should be able to parse playback_count");
    STAssertEquals(0, track.commentCount, @"Should be able to parse comment_count");
}

@end
