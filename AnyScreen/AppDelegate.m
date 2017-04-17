//
//  AppDelegate.m
//  AnyScreen
//
//  Created by pcbeta on 15/12/12.
//  Copyright © 2015年 xindawn. All rights reserved.
//

#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()
{
    AVPlayerViewController* playerVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"darkMode"] isEqual: @"true"]) {
        self.window.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        [[UILabel appearance] setTextColor:[UIColor whiteColor]];
        [[UIView appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    } else {
        self.window.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [[UILabel appearance] setTextColor:[UIColor blackColor]];
    }
    
    [[UIView appearance] setBackgroundColor:[UIColor clearColor]];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"%zd", [group numberOfAssets]);
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %zd", error.code);
        } else {
            NSLog(@"Other error code: %zd", error.code);
        }
    }];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // AZ DEBUG @@ iOS 7+
    AVAudioSessionRecordPermission sessionRecordPermission = [session recordPermission];
    switch (sessionRecordPermission) {
        case AVAudioSessionRecordPermissionUndetermined:
            NSLog(@"Mic permission indeterminate. Call method for indeterminate stuff.");
            break;
        case AVAudioSessionRecordPermissionDenied:
            NSLog(@"Mic permission denied. Call method for denied stuff.");
            break;
        case AVAudioSessionRecordPermissionGranted:
            NSLog(@"Mic permission granted.  Call method for granted stuff.");
            break;
        default:
            break;
    }
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    NSString *myBundlePath = @"GlitchBundle.bundle";
    NSBundle *myBundle = [NSBundle bundleWithPath:myBundlePath];
    /*NSString *translated = */
    NSLocalizedStringFromTableInBundle(@"CFBundleIdentifier",nil,myBundle,nil);
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"kdd: applicationWillResignActive");
    
    if(playerVC)
    {
        [playerVC enterBackground];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"kdd: applicationWillEnterForeground");
    
    if(playerVC)
    {
        [playerVC enterForeground];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setViewControllerToBeObserved:(AVPlayerViewController*)vc
{
    playerVC = vc;
}


@end
