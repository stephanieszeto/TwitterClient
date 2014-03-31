//
//  SSTweetViewController.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTweetViewController.h"
#import "SSComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SSTweet.h"
#import "TwitterClient.h"

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
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomRetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) TwitterClient *client;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;

@end

@implementation SSTweetViewController

- (SSTweetViewController *)initWithTweet:(SSTweet *)tweet {
    self = [super init];
    if (self) {
        self.title = @"Tweet";
        self.tweet = tweet;
        self.client = [TwitterClient instance];
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
    
    // set navigation bar colors
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add new button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleBordered target:self action:@selector(onReplyButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self setValues:self.tweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Navigation bar methods

- (void)onReplyButton {
    SSComposeViewController *cvc = [[SSComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

# pragma mark - private methods

- (void)setValues:(SSTweet *)tweet {
    self.name.text = tweet.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.numFavorites.text = [@(tweet.numFavorites) stringValue];
    self.numRetweets.text = [@(tweet.numRetweets) stringValue];
    
    [self.avatar setImageWithURL:tweet.user.avatarURL];
    
    // set tweet text
    self.tweetText.text = tweet.tweet;
    self.tweetText.numberOfLines = 0;
    self.tweetText.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect frame = self.tweetText.frame;
    frame.size.width = 300.0;
    self.tweetText.frame = frame;
    [self.tweetText sizeToFit];
    
    // set time
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [df dateFromString:tweet.time];
    NSString *time = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.time.text = time;
    
    if (!tweet.retweeter) {
        [self.topRetweetButton setHidden:YES];
        [self.retweeterLabel setHidden:YES];
    } else {
        self.topRetweetButton.image = [UIImage imageNamed:@"defaultRetweet"];
        self.retweeterLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.username];
    }
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"clicked on reply");
    self.replyButton.imageView.image = [UIImage imageNamed:@"hoverReply"];
    [self onReplyButton];
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
