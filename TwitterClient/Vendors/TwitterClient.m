//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/28/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "TwitterClient.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"biYAqubJD0rK2cRatIQTZw"
#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (void)login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Step 1: received request token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error: no request token");
    }];
}

- (AFHTTPRequestOperation *)timelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

@end
