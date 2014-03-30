//
//  SSUser.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSUser.h"

@implementation SSUser

- (SSUser *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.username = dictionary[@"screen_name"];
        self.name = dictionary[@"name"];
        self.avatarURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.tweets = [[NSMutableArray alloc] init];
        self.userDictionary = dictionary;
    }
    
    return self;
}

- (void)addTweet:(SSTweet *)tweet {
    [self.tweets addObject:tweet];
}

@end
