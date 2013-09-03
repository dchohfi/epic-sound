//
//  ESTrack.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESTrack.h"
#import "ESUser.h"
#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCNSURLConverter.h"
#import "TTTTimeIntervalFormatter.h"
@interface ESNSURLConverter : DCNSURLConverter

@end

@implementation ESTrack

+ (ESTrack *) trackWithData: (NSDictionary *) data {
    return [[self parser] parseDictionary:data];
}
+ (NSArray *) tracksWithData: (NSArray *) data {
    return [[self parser] parseArray:data];
}
+ (TTTTimeIntervalFormatter *) formatter {
    static TTTTimeIntervalFormatter *formatter = nil;
    if(formatter == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[TTTTimeIntervalFormatter alloc] init];
            [formatter setUsesIdiomaticDeicticExpressions:NO];
        });
    }
    return formatter;
}
+ (DCKeyValueObjectMapping *) parser {
    static DCKeyValueObjectMapping *parser = nil;
    if(parser == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            DCParserConfiguration *parserConfiguration = [DCParserConfiguration configuration];
            DCObjectMapping *idUserMapping = [DCObjectMapping mapKeyPath:@"id"
                                                         toAttribute:@"userId"
                                                             onClass:[ESUser class]];
            DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"id"
                                                         toAttribute:@"trackId"
                                                             onClass:[ESTrack class]];
            DCObjectMapping *artworkUrlMapping = [DCObjectMapping mapKeyPath:@"artwork_url"
                                                                 toAttribute:@"artworkUrl"
                                                                     onClass:[ESTrack class]
                                                                    converter:[[ESNSURLConverter alloc] init]];
            [parserConfiguration addObjectMapping:idUserMapping];
            [parserConfiguration addObjectMapping:idMapping];
            [parserConfiguration addObjectMapping:artworkUrlMapping];
            [parserConfiguration setDatePattern:@"yyyy/MM/dd HH:mm:ss ZZZ"];
            parser = [DCKeyValueObjectMapping mapperForClass:[ESTrack class]
                                            andConfiguration:parserConfiguration];
        });
    }
    return parser;
}
- (NSURL *) soundCloudURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"soundcloud:tracks:%i", self.trackId]];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%i - %@", self.trackId, self.title];
}
- (NSURL *)artworkUrl {
    return _artworkUrl ? _artworkUrl : self.user.avatarUrl;
}
- (NSString *)timeIntervalSinceCreatedAt {
    if(!_timeIntervalSinceCreatedAt){
        _timeIntervalSinceCreatedAt = [[[self class] formatter] stringForTimeInterval:self.createdAt.timeIntervalSinceNow];
    }
    return _timeIntervalSinceCreatedAt;
}
@end


@implementation ESNSURLConverter

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return [super transformValue:value
             forDynamicAttribute:attribute
                      dictionary:dictionary
                    parentObject:parentObject];
}

@end
