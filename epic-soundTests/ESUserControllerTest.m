//
//  ESUserControllerTest.m
//  epic-sound
//
//  Created by Diego Chohfi on 9/5/13.
//  Copyright (c) 2013 Diego Chohfi. All rights reserved.
//

#import "ESUserControllerTest.h"
#import "ESUserController.h"
#import "OHHTTPStubs.h"
@interface ESUserControllerTest()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation ESUserControllerTest

- (void)runTestWithBlock:(void (^)(void))block {
    self.semaphore = dispatch_semaphore_create(0);
    
    block();
    
    while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

- (void)blockTestCompletedWithBlock:(void (^)(void))block {
    dispatch_semaphore_signal(self.semaphore);
    
    if (block) {
        block();
    }
}

- (void) testShouldCallErrorBlockOnUserDataForInvalidJsonResponse {
    [self runTestWithBlock:^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFile:@"bad_user.json"
                                             contentType:@"text/json"
                                            responseTime:1.0];
        }];
        
        
        [[ESUserController userController] getUserData:^(ESUser *user) {
            [self blockTestCompletedWithBlock:^{
                STFail(@"Should not come to the success block for an invalid parsed response");
            }];
        } failure:^(NSError *error) {
            [self blockTestCompletedWithBlock:^{
                STAssertNotNil(error, @"Should return an error for invalid response");
            }];
        }];
    }];
}
- (void) testShouldCallErrorBlockOnUserLikesForInvalidJsonResponse {
    [self runTestWithBlock:^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFile:@"bad_track.json"
                                             contentType:@"text/json"
                                            responseTime:1.0];
        }];
        
        
        [[ESUserController userController] getUserLikes:^(NSArray *likes) {
            [self blockTestCompletedWithBlock:^{
                STFail(@"Should not come to the success block for an invalid parsed response");
            }];
        } failure:^(NSError *error) {
            [self blockTestCompletedWithBlock:^{
                STAssertNotNil(error, @"Should return an error for invalid response");
            }];
        }];
    }];
}
- (void) testShouldCallErrorBlockForBadResponseOnUserEndPoint {
    [self runTestWithBlock:^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                              code:kCFURLErrorNotConnectedToInternet
                                                                          userInfo:nil]];
        }];
        
        [[ESUserController userController] getUserData:^(ESUser *user) {
            [self blockTestCompletedWithBlock:^{
                STFail(@"Should not come to the success block when no connection");
            }];
        } failure:^(NSError *error) {
            [self blockTestCompletedWithBlock:^{
                STAssertEqualObjects(@"The Internet connection appears to be offline.", [error localizedDescription], @"The  error message when no connection should be the same");
                STAssertNotNil(error, @"Should return an error when no connection is available");
            }];
        }];
    }];
}
- (void) testShouldCallErrorBlockForBadResponseOnLikesEndPoint {
    [self runTestWithBlock:^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                              code:kCFURLErrorNotConnectedToInternet
                                                                          userInfo:nil]];
        }];
        
        [[ESUserController userController] getUserLikes:^(NSArray *likes) {
            [self blockTestCompletedWithBlock:^{
                STFail(@"Should not come to the success block when no connection");
            }];
        } failure:^(NSError *error) {
            [self blockTestCompletedWithBlock:^{
                STAssertEqualObjects(@"The Internet connection appears to be offline.", [error localizedDescription], @"The  error message when no connection should be the same");
                STAssertNotNil(error, @"Should return an error when no connection is available");
            }];
        }];
    }];
}
- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
}
@end
