//
//  AppDelegate.m
//  BBSCycleBannerView
//
//  Created by 付航 on 2018/12/13.
//  Copyright © 2018年 BBS. All rights reserved.
//

#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString*userAgent=@"";userAgent=[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)",[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleExecutableKey]?:[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleIdentifierKey],[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]?:[[[NSBundle mainBundle]infoDictionary]objectForKey:(__bridge NSString*)kCFBundleVersionKey],[[UIDevice currentDevice]model],[[UIDevice currentDevice]systemVersion],[[UIScreen mainScreen]scale]];
    if(userAgent) {
        if(![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString*mutableUserAgent=[userAgent mutableCopy];
            if(CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent),NULL,(__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove",false)){
                userAgent=mutableUserAgent;
                
            }
            
        }
        [[SDWebImageDownloader sharedDownloader]setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
