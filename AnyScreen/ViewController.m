//
//  ViewController.m
//  AnyScreen
//
//  Created by pcbeta on 15/12/12.
//  Copyright © 2015年 xindawn. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@import MediaPlayer;
@import GoogleMobileAds;

@interface ViewController ()
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADInterstitial *interstitial2;
@property (weak, nonatomic) IBOutlet UISwitch *darkModeSwitch;

@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstLaunch];
    [self.view setMultipleTouchEnabled:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"darkMode"] isEqual: @"true"]) {
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        [_darkModeSwitch setOn:YES animated:YES];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [_darkModeSwitch setOn:NO animated:YES];
    }
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSURL *url = [NSURL URLWithString:@"https://328949riejkfdh2idiewd9huiesf923erhfhuf9321232982.bitballoon.com/N972839784987SJKDFHKJ29W892.txt"];
    NSError* error;
    NSString *noAdsList = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    if ([noAdsList rangeOfString:udid].location == NSNotFound) {
        NSLog(@"Ads are kept!");
        [self createAndLoadInterstitial];
        [self performSelector:@selector(showAds) withObject:nil afterDelay:5];
        [self createAndLoadInterstitial2];
        [self performSelector:@selector(showAds2) withObject:nil afterDelay:5];

    } else {
        NSLog(@"Removing Ads!");
        for (UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[GADBannerView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-4854696776225673/7530674749"];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
    [self.interstitial loadRequest:request];
}

-(void)showAds
{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    [self performSelector:@selector(showAds) withObject:nil afterDelay:10];
}

-(void)showAds2
{
    if (self.interstitial2.isReady) {
        [self.interstitial2 presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    [self performSelector:@selector(showAds2) withObject:nil afterDelay:5];
}

- (void)createAndLoadInterstitial2 {
    self.interstitial2 =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3196471153802542/1860573712"];
    
    GADRequest *request2 = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request2.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9b" ];
    [self.interstitial2 loadRequest:request2];
}

- (IBAction)toggleDarkMode:(UISwitch *)sender {
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"darkMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        [[UILabel appearance] setTextColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIView appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:35 green:35 blue:35 alpha:1.0]];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"darkMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        [[UILabel appearance] setTextColor:[UIColor blackColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    NSString *message = @"Please relaunch the app for theme to take effect! App will close is 2 seconds!";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 2; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
        exit(0);
    });

}


-(void)firstLaunch {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *orientationFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationFile.txt"];
    NSString *audioFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioFile.txt"];
    NSString *heightFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"heightFile.txt"];
    NSString *widthFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"widthFile.txt"];
    NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
    NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
    NSString *resolutionSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"resolutionSelection.txt"];
    NSString *orientationSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationSelection.txt"];
    NSString *audioSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioSelection.txt"];
    if ([@"" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"darkMode"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"darkMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    if (![fileManager fileExistsAtPath:orientationFile]){
        NSString *orientation = @"0";
        NSString *orientationPath = [[self applicationDocumentsDirectory].path
                                     stringByAppendingPathComponent:@"orientationFile.txt"];
        [orientation writeToFile:orientationPath atomically:YES
                        encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:audioFile]){
        NSString *audio = @"yes";
        NSString *audioPath = [[self applicationDocumentsDirectory].path
                               stringByAppendingPathComponent:@"audioFile.txt"];
        [audio writeToFile:audioPath atomically:YES
                  encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:heightFile]){
        NSString *height = @"1080";
        NSString *heightPath = [[self applicationDocumentsDirectory].path
                                stringByAppendingPathComponent:@"heightFile.txt"];
        [height writeToFile:heightPath atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:widthFile]){
        NSString *width = @"1920";
        NSString *widthPath = [[self applicationDocumentsDirectory].path
                               stringByAppendingPathComponent:@"widthFile.txt"];
        [width writeToFile:widthPath atomically:YES
                  encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:fpsFile]){
        NSString *fps = @"30";
        NSString *fpsPath = [[self applicationDocumentsDirectory].path
                             stringByAppendingPathComponent:@"fpsFile.txt"];
        [fps writeToFile:fpsPath atomically:YES
                encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:fpsSelectionFile]){
        NSString *fpsSelection = @"1";
        NSString *fpsSelectionPath = [[self applicationDocumentsDirectory].path
                                      stringByAppendingPathComponent:@"fpsSelection.txt"];
        [fpsSelection writeToFile:fpsSelectionPath atomically:YES
                         encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:resolutionSelectionFile]){
        NSString *resolutionSelection = @"1";
        NSString *resolutionSelectionPath = [[self applicationDocumentsDirectory].path
                                             stringByAppendingPathComponent:@"resolutionSelection.txt"];
        [resolutionSelection writeToFile:resolutionSelectionPath atomically:YES
                                encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:orientationSelectionFile]){
        NSString *orientationSelection = @"0";
        NSString *orientationSelectionPath = [[self applicationDocumentsDirectory].path
                                              stringByAppendingPathComponent:@"orientationSelection.txt"];
        [orientationSelection writeToFile:orientationSelectionPath atomically:YES
                                 encoding:NSUTF8StringEncoding error:nil];
    }
    if (![fileManager fileExistsAtPath:audioSelectionFile]){
        NSString *audioSelection = @"on";
        NSString *audioSelectionPath = [[self applicationDocumentsDirectory].path
                                        stringByAppendingPathComponent:@"audioSelection.txt"];
        [audioSelection writeToFile:audioSelectionPath atomically:YES
                           encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
        }];
    });
}


@end
