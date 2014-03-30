//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Stephanie Szeto on 3/28/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "AppDelegate.h"
#import "SSLoginViewController.h"
#import "SSTimelineViewController.h"
#import "TwitterClient.h"
#import "SSTweet.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *nvc;

@end

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SSLoginViewController *lvc = [[SSLoginViewController alloc] init];
    self.nvc = [[UINavigationController alloc] initWithRootViewController:lvc];;
    self.window.rootViewController = self.nvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"cptwitter"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            NSLog(@"Step 2: received access code");
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    // get access token
                    [client.requestSerializer saveAccessToken:accessToken];
                    NSLog(@"Step 3: received access token");
                    
                    // make API calls
                    [client timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //NSLog(@"timeline response: %@", responseObject);
                        
                        // populate models
                        NSArray *tweetsInJson = responseObject;
                        NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:tweetsInJson.count];
                        for (NSDictionary *dictionary in tweetsInJson) {
                            SSTweet *tweet = [[SSTweet alloc] initWithDictionary:dictionary];
                            [tweets addObject:tweet];
                        }
                        
                        // push timeline view controller
                        SSTimelineViewController *tvc = [[SSTimelineViewController alloc] initWithArray:tweets];
                        [self.nvc pushViewController:tvc animated:YES];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: no timeline response");
                    }];
                    

                } failure:^(NSError *error) {
                    NSLog(@"Error: no access token");
                }];
            }
        }
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
