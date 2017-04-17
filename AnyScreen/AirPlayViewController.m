//
//  AirPlayViewController.m
//  PixlRec
//
//  Created by Joseph on 2/4/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "AirPlayViewController.h"
#import "CSScreenRecorder.h"
#import "IDFileManager.h"

#include <mach/mach_time.h>
#import <objc/message.h>
#import <AudioToolbox/AudioToolbox.h>
#import <dlfcn.h>
#include <sys/time.h>
#import <QuartzCore/QuartzCore.h>
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@import MediaPlayer;
@import GoogleMobileAds;

@interface AirPlayViewController ()<CSScreenRecorderDelegate>
{
    BOOL bRecording;
    CSScreenRecorder *_screenRecorder;
    MPVolumeView *volumeView;
    id routerController;
    NSString *airplayName;
    
    BOOL shouldConnect;
}
@property (weak, nonatomic) IBOutlet UIButton *stoppppp;

@property (weak, nonatomic) IBOutlet UIView *mpView;
@property (weak, nonatomic) IBOutlet UIWebView *managerWebView;

@end

@implementation AirPlayViewController

NSTimer *myTimer;

- (void)setupAirplayMonitoring
{
    if (!routerController) {
        routerController = [NSClassFromString(@"MPAVRoutingController") new];
        [routerController setValue:self forKey:@"delegate"];
        [routerController setValue:[NSNumber numberWithLong:2] forKey:@"discoveryMode"];
    }
}

/*
 -(void)routingControllerAvailableRoutesDidChange:(id)arg1{
 if (airplayName == nil) {
 return;
 }
 NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
 for (id router in availableRoutes) {
 NSString *routerName = [router valueForKey:@"routeName"];
 if ([routerName rangeOfString:airplayName].length >0) {
 BOOL picked = [[router valueForKey:@"picked"] boolValue];
 if (picked == NO) {
 [routerController performSelector:@selector(pickRoute:) withObject:router];
 }
 return;
 }
 }
 }
 */

-(void)routingControllerAvailableRoutesDidChange:(id)arg1{
    NSLog(@"arg1-%@",arg1);
    if (airplayName == nil) {
        return;
    }
    
    NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
    for (id router in availableRoutes) {
        NSString *routerName = [router valueForKey:@"routeName"];
        NSLog(@"routername -%@",routerName);
        if ([routerName rangeOfString:airplayName].length >0) {
            BOOL picked = [[router valueForKey:@"picked"] boolValue];
            if (picked == NO && !shouldConnect) {
                shouldConnect = TRUE;
                NSLog(@"connect once");
                NSString *one = @"p";
                NSString *two = @"ickR";
                NSString *three = @"oute:";
                NSString *path = [[one stringByAppendingString:two] stringByAppendingString:three];
                [routerController performSelector:NSSelectorFromString(path) withObject:router];
                //objc_msgSend(self.routerController,NSSelectorFromString(path),router);
            }
            return;
        }
    }
}

- (void)checkIt {
    if ([[UIScreen screens] count] < 2) {
        //streaming
    }
    else {
        [myTimer invalidate];
        myTimer = nil;
        NSString *message = @"Recording Started.";
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:3];
        notification.alertBody = @"PixlRec Is Recording! @PixlRec on Twitter!";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0.1];
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        int duration = 1; // in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        AudioServicesPlaySystemSound(1118);
        void *SpringBoardServices = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
        NSParameterAssert(SpringBoardServices);
        mach_port_t (*SBSSpringBoardServerPort)() = dlsym(SpringBoardServices, "SBSSpringBoardServerPort");
        NSParameterAssert(SBSSpringBoardServerPort);
        SpringBoardServicesReturn (*SBSuspend)(mach_port_t port) = dlsym(SpringBoardServices, "SBSuspend");
        NSParameterAssert(SBSuspend);
        mach_port_t sbsMachPort = SBSSpringBoardServerPort();
        SBSuspend(sbsMachPort);
        dlclose(SpringBoardServices);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkIt) userInfo:nil repeats:YES];

    bRecording = YES;
    [self.mpView setHidden:NO];
    [self.view setMultipleTouchEnabled:YES];
    _stoppppp.backgroundColor = [UIColor whiteColor];
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:120.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        //NSData receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    // automatic airplay connection
    shouldConnect = TRUE;
    airplayName = @"PixlRec";
    [self setupAirplayMonitoring];
    
    
    bRecording = NO;
    _screenRecorder = [CSScreenRecorder sharedCSScreenRecorder];
    
    //[self.labelTime setHidden:YES];
    
#if 0
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
    
    [self.view addSubview:volumeView];
    [volumeView sizeToFit];
#endif
    
#if 1
    
    CGRect rect;
    rect = self.mpView.frame;
    rect.origin.x = rect.origin.y = 0;
    
    volumeView = [[MPVolumeView alloc] initWithFrame:rect];
    //MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
    
    [volumeView setShowsVolumeSlider:NO];
    
    [volumeView sizeToFit];
    [self.mpView addSubview:volumeView];
    
    [volumeView becomeFirstResponder];
    [volumeView setShowsRouteButton:YES];
    [volumeView setRouteButtonImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
    [volumeView setRouteButtonImage:nil forState:UIControlStateNormal];
#if 0
    {
        NSLayoutConstraint* contentViewConstraint =
        [NSLayoutConstraint	 constraintWithItem:volumeView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.0
                                       constant:0];
        [self.view addConstraint:contentViewConstraint];
    }
    
    {
        NSLayoutConstraint* contentViewConstraint =
        [NSLayoutConstraint	 constraintWithItem:volumeView
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1.0
                                       constant:0];
        [self.view addConstraint:contentViewConstraint];
    }
    
    {
        NSLayoutConstraint* contentViewConstraint =
        [NSLayoutConstraint	 constraintWithItem:volumeView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                       constant:0];
        [self.view addConstraint:contentViewConstraint];
    }
#endif
    
#endif
}

- (void)screenRecorder:(CSScreenRecorder *)recorder recordingTimeChanged:(NSTimeInterval)recordingTime
{// time in seconds since start of capture
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSString *string = [NSString stringWithFormat:@"%02li:%02li:%02li",
        //lround(floor(recordingTime / 3600.)) % 100,
        //lround(floor(recordingTime / 60.)) % 60,
        //lround(floor(recordingTime)) % 60];
        //[self.labelTime setText:string];
        //_labelTime.text = string;
        //        [self.mpView setHidden:NO];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stopRecording:(id)sender {
    AudioServicesPlaySystemSound (1117);
    [self stopRecord];
    [self.view endEditing:YES];
    NSString *message = @"Recording Finished.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 3; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
        [self dismiss];

    });

}

- (void)dismiss {
[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)stopRecord
{
    
    shouldConnect = FALSE;
    airplayName = @"PixlRec";
    
    [_screenRecorder stopRecordingScreen];
    bRecording = NO;
    
    //  [self.mpView setHidden:NO];
    
    
    /*
     NSString *airplayNameiPhone = @"iPhone";
     NSArray *availableRoutes = [routerController valueForKey:@"availableRoutes"];
     for (id router in availableRoutes) {
     NSString *routerName = [router valueForKey:@"routeName"];
     if ([routerName rangeOfString:airplayNameiPhone].length >0) {
     BOOL picked = [[router valueForKey:@"picked"] boolValue];
     //usleep(1000*1000);
     if (picked == NO) {
     [routerController performSelector:@selector(pickRoute:) withObject:router];
     }
     return;
     }
     }*/
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
