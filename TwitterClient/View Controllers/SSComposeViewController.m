//
//  SSComposeViewController.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSComposeViewController.h"
#import "SSTimelineViewController.h"
#import "SSUser.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface SSComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (nonatomic, strong) TwitterClient *client;

@end

@implementation SSComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.client) {
            self.client = [TwitterClient instance];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up tweet button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(onTweetClick)];
    
    // set up cancel button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelClick)];
    
    // set up values
    [self setValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValues {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDictionary = [defaults objectForKey:@"currentUser"];
    SSUser *user = [[SSUser alloc] initWithDictionary:userDictionary];
    
    self.name.text = user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", user.username];
    [self.avatar setImageWithURL:user.avatarURL];
}

# pragma mark - Navigation bar methods

- (void)onTweetClick {
    // post tweet
    NSString *input = self.tweetText.text;
    [self.client tweetWithSuccess:@{@"tweetText" : input} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweeted!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    // return back to places view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCancelClick {
    // return back to places view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end
