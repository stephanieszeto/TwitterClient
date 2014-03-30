//
//  SSRetweetCell.h
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/30/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTweet.h"

@interface SSRetweetCell : UITableViewCell

@property (nonatomic, strong) SSTweet *tweet;

- (void)setValues:(SSTweet *)tweet;

@end
