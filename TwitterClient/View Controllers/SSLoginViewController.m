//
//  SSLoginViewController.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/28/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSLoginViewController.h"
#import "TwitterClient.h"

@interface SSLoginViewController ()

- (IBAction)onLoginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIView *labelBox;

@end

@implementation SSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up background color
    self.background.backgroundColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.labelBox.layer.borderWidth = 1.0f;
    self.labelBox.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [[TwitterClient instance] login];
}
@end
