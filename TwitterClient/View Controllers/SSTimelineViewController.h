//
//  SSTimelineViewController.h
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTimelineViewController : UIViewController < UITableViewDataSource,UITableViewDelegate >

@property (nonatomic, strong) NSMutableArray *tweets;

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array;

@end
