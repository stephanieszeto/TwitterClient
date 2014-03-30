//
//  SSTweetViewController.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SSTweet.h"

@interface SSTweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topRetweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
@property (weak, nonatomic) IBOutlet UIImageView *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRetweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteButton;

@end

@implementation SSTweetViewController

- (SSTweetViewController *)initWithTweet:(SSTweet *)tweet {
    self = [super init];
    if (self) {
        self.title = @"Tweet";
        self.tweet = tweet;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setValues:self.tweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValues:(SSTweet *)tweet {
    self.name.text = tweet.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.numFavorites.text = [@(tweet.numFavorites) stringValue];
    self.numRetweets.text = [@(tweet.numRetweets) stringValue];
    [self.avatar setImageWithURL:tweet.user.avatarURL];
    
    self.tweetText.text = tweet.tweet;
    self.tweetText.numberOfLines = 0;
    self.tweetText.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect frame = self.tweetText.frame;
    frame.size.width = 300.0;
    self.tweetText.frame = frame;
    [self.tweetText sizeToFit];
    
    // compute time
    self.time.text = tweet.time;
    if (!tweet.retweeter) {
        [self.topRetweetButton setHidden:YES];
        [self.retweeterLabel setHidden:YES];
    } else {
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.username];
    }
}

@end
