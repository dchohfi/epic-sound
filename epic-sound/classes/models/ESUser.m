//
//  ESUser.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/2/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESUser.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"

@implementation ESUser

+ (ESUser *) userWithData: (NSDictionary *) data {
    return [[self parser] parseDictionary:data];
}

+ (DCKeyValueObjectMapping *) parser {
    static DCKeyValueObjectMapping *parser = nil;
    if(parser == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            DCParserConfiguration *parserConfiguration = [DCParserConfiguration configuration];
            DCObjectMapping *idMapping = [DCObjectMapping mapKeyPath:@"id"
                                                         toAttribute:@"userId"
                                                             onClass:[ESUser class]];
            [parserConfiguration addObjectMapping:idMapping];
            parser = [DCKeyValueObjectMapping mapperForClass:[ESUser class]
                                            andConfiguration:parserConfiguration];
        });
    }
    return parser;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%i - %@ - %@", self.userId, self.username, self.fullName];
}
@end
