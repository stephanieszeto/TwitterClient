//
//  SSTimelineViewController.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/29/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTimelineViewController.h"
#import "SSComposeViewController.h"
#import "SSTweetViewController.h"
#import "SSTweetCell.h"
#import "SSRetweetCell.h"
#import "SSTweet.h"

@interface SSTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SSTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        self.title = @"Home";
        self.tweets = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // set navigation bar colors
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add new button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(onNewButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    // register tweet cell
    UINib *tweetNib = [UINib nibWithNibName:@"SSTweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"SSTweetCell"];
    
    // register retweet cell
    UINib *retweetNib = [UINib nibWithNibName:@"SSRetweetCell" bundle:nil];
    [self.tableView registerNib:retweetNib forCellReuseIdentifier:@"SSRetweetCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Navigation bar methods

- (void)onNewButton {
    SSComposeViewController *cvc = [[SSComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSTweet *tweet = self.tweets[indexPath.row];
    if (!tweet.retweeter) {
        return 120;
    } else {
        return 150;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSTweet *tweet = self.tweets[indexPath.row];
    if (!tweet.retweeter) {
        SSTweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"SSTweetCell" forIndexPath:indexPath];
        [tweetCell setValues:tweet];
        return tweetCell;
    } else {
        SSRetweetCell *retweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"SSRetweetCell" forIndexPath:indexPath];
        [retweetCell setValues:tweet];
        return retweetCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSTweet *tweet = self.tweets[indexPath.row];
    
    // push tweet view controller
    SSTweetViewController *tvc = [[SSTweetViewController alloc] initWithTweet:tweet];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
