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
#import "SSLoginViewController.h"
#import "SSTweetCell.h"
#import "SSRetweetCell.h"
#import "SSTweet.h"
#import "TwitterClient.h"

@interface SSTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TwitterClient *client;

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
    self.client = [TwitterClient instance];
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // set navigation bar colors
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add sign out button to navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(onSignOutButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    // add new button to navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(onNewButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    // add pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
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

- (void)callCompose {
    SSComposeViewController *cvc = [[SSComposeViewController alloc] init];
    // for later: set reply screen_name
    [self.navigationController pushViewController:cvc animated:YES];
}

# pragma mark - Private methods

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadTimeline];
    [refreshControl endRefreshing];
}

- (void)loadTimeline {
    [self.client timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // populate models
        [self.tweets removeAllObjects];
        NSArray *tweetsInJson = responseObject;
        NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:tweetsInJson.count];
        for (NSDictionary *dictionary in tweetsInJson) {
            SSTweet *tweet = [[SSTweet alloc] initWithDictionary:dictionary];
            [tweets addObject:tweet];
        }
        self.tweets = tweets;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: no timeline response");
    }];
    [self.tableView reloadData];
}

# pragma mark - Navigation bar methods

- (void)onNewButton {
    SSComposeViewController *cvc = [[SSComposeViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)onSignOutButton {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentUser"];
    [self.tweets removeAllObjects];
    
    SSLoginViewController *lvc = [[SSLoginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
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
        tweetCell.delegate = self;
        [tweetCell setValues:tweet];
        return tweetCell;
    } else {
        SSRetweetCell *retweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"SSRetweetCell" forIndexPath:indexPath];
        retweetCell.delegate = self;
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
