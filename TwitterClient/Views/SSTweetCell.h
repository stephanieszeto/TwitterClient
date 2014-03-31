//
//  SSTweetCell.h
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTweet.h"

@class SSTweetCell;

@protocol SSTweetCellDelegate <NSObject>

- (void)callCompose;

@end

@interface SSTweetCell : UITableViewCell

@property (nonatomic, strong) SSTweet *tweet;
@property (nonatomic, weak) id <SSTweetCellDelegate> delegate;

- (void)setValues:(SSTweet *)tweet;

@end
