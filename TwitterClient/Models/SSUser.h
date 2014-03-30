//
//  SSUser.h
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSTweet;

@interface SSUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSDictionary *userDictionary;

- (SSUser *)initWithDictionary:(NSDictionary *)dictionary;
- (void)addTweet:(SSTweet *)tweet;

@end
