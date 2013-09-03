//
//  ESUserParserTest.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESUserParserTest.h"
#import "ESUser.h"
@interface ESUserParserTest()

@property (nonatomic, strong) NSDictionary *userJson;

@end

@implementation ESUserParserTest

- (void)setUp {
    [super setUp];
    NSString *jsonPath = [[NSBundle bundleForClass: [self class]] pathForResource:@"user" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    self.userJson = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers error:nil];
}

- (void) testShouldBeAbleToParseValidJson {
    ESUser *user = [ESUser userWithData:self.userJson];
    STAssertEquals(3207, user.userId, @"Should be able to parse userId correcly");
    STAssertEqualObjects(@"Johannes Wagener", user.username, @"Should be able to parse username correcly");
    STAssertEqualObjects([NSURL URLWithString:@"http://i1.sndcdn.com/avatars-000001552142-pbw8yd-large.jpg?142a848"], user.avatarUrl, @"Should be able to parse avatar_url correcly");
    STAssertEqualObjects(@"Germany", user.country, @"Should be able to parse coutry correcly");
    STAssertEqualObjects(@"Johannes Wagener", user.fullName, @"Should be able to parse full_name correcly");
    STAssertEqualObjects(@"Berlin", user.city, @"Should be able to parse city correcly");
    STAssertEquals(417, user.followersCount, @"Should be able to parse followers_count correcly");
    STAssertEquals(174, user.followingsCount, @"Should be able to parse followings_count correcly");
}

@end
