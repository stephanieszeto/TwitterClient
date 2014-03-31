//
//  SSRetweetCell.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/30/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSRetweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "SSTweet.h"

@interface SSRetweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *topRetweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweeterLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomRetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) TwitterClient *client;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;

@end

@implementation SSRetweetCell

- (void)setValues:(SSTweet *)tweet {
    if (!self.client) {
        self.client = [TwitterClient instance];
    }
    
    self.tweet = tweet;
    self.name.text = tweet.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.username];
    
    [self.avatar setImageWithURL:tweet.user.avatarURL];
    self.topRetweetButton.image = [UIImage imageNamed:@"defaultRetweet"];
    
    self.tweetText.text = tweet.tweet;
    self.tweetText.numberOfLines = 0;
    self.tweetText.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect frame = self.tweetText.frame;
    frame.size.width = 225.0;
    self.tweetText.frame = frame;
    [self.tweetText sizeToFit];
    
    // compute time
    self.time.text = [self findTime:tweet.time];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark - private methods

- (NSString *)findTime:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if (ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"1m";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
    	return @"never";
    }
}

- (IBAction)onReplyButton:(id)sender {
    self.replyButton.imageView.image = [UIImage imageNamed:@"hoverReply"];
    [self.delegate callCompose];
}

- (IBAction)onRetweetButton:(id)sender {
    self.bottomRetweetButton.imageView.image = [UIImage imageNamed:@"onRetweet"];
    // make API call to retweet
    NSLog(@"id: %@", self.tweet.id);
    NSDictionary *parameter = @{@"tweetId" : self.tweet.id};
    [self.client retweetWithSuccess:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweeted!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (IBAction)onFavoriteButton:(id)sender {
    self.favoriteButton.imageView.image = [UIImage imageNamed:@"onFavorite"];
    // make API call to favorite
    NSDictionary *parameter = @{@"tweetId" : self.tweet.id};
    [self.client favoriteWithSuccess:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Favorited!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

@end
