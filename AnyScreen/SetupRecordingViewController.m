//
//  SetupRecordingViewController.m
//  PixlRec
//
//  Created by Joseph on 21/3/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "SetupRecordingViewController.h"
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

@interface SetupRecordingViewController ()<CSScreenRecorderDelegate>
{
    BOOL bRecording;
    CSScreenRecorder *_screenRecorder;
    MPVolumeView *volumeView;
    id routerController;
    NSString *airplayName;
    
    BOOL shouldConnect;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordBtn;
@property (weak, nonatomic) IBOutlet UIView *mpView;
//@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIWebView *managerWebView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UITextField *videoName;

@end

@implementation SetupRecordingViewController

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
                //[routerController performSelector:NSSelectorFromString(path) withObject:router];
                //objc_msgSend(self.routerController,NSSelectorFromString(path),router);
            }
            return;
        }
    }
}



- (NSString*)generateMP4Name:(NSString*)name
{
    if (_videoName.text && _videoName.text.length > 0)
    {
    NSString *fname = name;
        return [IDFileManager inDocumentsDirectory:fname];
    } else {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSString *fname = [NSString stringWithFormat:@"%@", currentTime];
        return [IDFileManager inDocumentsDirectory:fname];
    }
    
}
- (void)startRecord
{
    
    shouldConnect = FALSE;
    airplayName = @"PixlRec";
    NSString *name = _videoName.text;
    _screenRecorder.videoOutPath = [self generateMP4Name:name];
    [_screenRecorder startRecordingScreen];
    bRecording = YES;
    [self.mpView setHidden:NO];
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

- (IBAction)recordThisShit:(id)sender {
    if(bRecording)
    {
        AudioServicesPlaySystemSound (1117);
        [self stopRecord];
        [self.view endEditing:YES];
        _recordBtn.title = @"Record";
        NSString *urlString = @"https://PixlRec.com/removeRecording.php";
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_managerWebView loadRequest:urlRequest];
        NSString *message = @"Recording Finished.";
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        int duration = 1; // in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
            if (self.interstitial.isReady) {
                [self.interstitial presentFromRootViewController:self];
            } else {
                NSLog(@"Ad wasn't ready");
            }
        });
    }
    else
    {
        //if (_videoName.text && _videoName.text.length > 0)
        //{
            //AudioServicesPlaySystemSound(1118);
            [self startRecord];
            [self.view endEditing:YES];
            _recordBtn.title = @"";
            NSString *urlString = @"https://PixlRec.com/addRecording.php";
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            [_managerWebView loadRequest:urlRequest];
            if (self.interstitial.isReady) {
                [self.interstitial presentFromRootViewController:self];
            } else {
                NSLog(@"Ad wasn't ready");
            }
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AirPlayController"];
        [self presentViewController:vc animated:YES completion:nil];
        //}
        /*else
        {
            NSString *message = @"Please name your video.";
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [toast show];
        } */

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_screenRecorder setDelegate:self];
    
    //    [self startRecord];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view endEditing:YES];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *fname = [NSString stringWithFormat:@"%@", currentTime];
    _videoName.placeholder = fname;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    [self.view setMultipleTouchEnabled:YES];
    NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
    NSString *fpsSelection = [NSString stringWithContentsOfFile:fpsSelectionFile encoding:NSUTF8StringEncoding error:nil];
    int fpsSelectionReal = [fpsSelection intValue];
    _fpsSelector.selectedSegmentIndex = fpsSelectionReal;
    NSString *resolutionSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"resolutionSelection.txt"];
    NSString *resolutionSelection = [NSString stringWithContentsOfFile:resolutionSelectionFile encoding:NSUTF8StringEncoding error:nil];
    int resolutionSelectionReal = [resolutionSelection intValue];
    _resolutionSelector.selectedSegmentIndex = resolutionSelectionReal;
    NSString *orientationSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationSelection.txt"];
    NSString *orientationSelection = [NSString stringWithContentsOfFile:orientationSelectionFile encoding:NSUTF8StringEncoding error:nil];
    int orientationSelectionReal = [orientationSelection intValue];
    _orientationSelector.selectedSegmentIndex = orientationSelectionReal;
    NSString *audioSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioSelection.txt"];
    NSString *audioSelection = [NSString stringWithContentsOfFile:audioSelectionFile encoding:NSUTF8StringEncoding error:nil];
    if ([audioSelection  isEqual: @"on"]) {
        [_audioSwitch setOn:YES animated:YES];
    }
    if ([audioSelection  isEqual: @"off"]) {
        [_audioSwitch setOn:NO animated:YES];
    }
    [self.view setMultipleTouchEnabled:YES];
    
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
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }

}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelRecording:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resolutionChanged:(UISegmentedControl *)sender {
    // Change Resolution
    NSString *resolution = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if ([resolution isEqual: @"1080p"]) {
        NSString *heightFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"heightFile.txt"];
        NSString *newHeight = @"1080";
        [newHeight writeToFile:heightFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *widthFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"widthFile.txt"];
        NSString *newWidth = @"1920";
        [newWidth writeToFile:widthFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *resolutionSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"resolutionSelection.txt"];
        NSString *newResolutionSelection = @"1";
        [newResolutionSelection writeToFile:resolutionSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([resolution isEqual: @"720p"]) {
        NSString *heightFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"heightFile.txt"];
        NSString *newHeight = @"720";
        [newHeight writeToFile:heightFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *widthFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"widthFile.txt"];
        NSString *newWidth = @"1280";
        [newWidth writeToFile:widthFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *resolutionSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"resolutionSelection.txt"];
        NSString *newResolutionSelection = @"0";
        [newResolutionSelection writeToFile:resolutionSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([resolution isEqual: @"1440p"]) {
        NSString *heightFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"heightFile.txt"];
        NSString *newHeight = @"1440";
        [newHeight writeToFile:heightFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *widthFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"widthFile.txt"];
        NSString *newWidth = @"2560";
        [newWidth writeToFile:widthFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *resolutionSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"resolutionSelection.txt"];
        NSString *newResolutionSelection = @"2";
        [newResolutionSelection writeToFile:resolutionSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (IBAction)fpsChanged:(UISegmentedControl *)sender {
    //Change FPS
    NSString *fps = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if ([fps isEqual: @"30 FPS"]) {
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = @"390";
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"0";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([fps isEqual: @"60 FPS"]) {
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = @"420";
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"1";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (IBAction)changeOrientation:(UISegmentedControl *)sender {
    NSString *resolution = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if ([resolution isEqual: @"Portrait"]) {
        NSString *orientationFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationFile.txt"];
        NSString *newOrientation = @"0";
        [newOrientation writeToFile:orientationFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *orientationSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationSelection.txt"];
        NSString *newOrientationSelection = @"0";
        [newOrientationSelection writeToFile:orientationSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([resolution isEqual: @"HB Right"]) {
        NSString *orientationFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationFile.txt"];
        NSString *newOrientation = @"270";
        [newOrientation writeToFile:orientationFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *orientationSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationSelection.txt"];
        NSString *newOrientationSelection = @"1";
        [newOrientationSelection writeToFile:orientationSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([resolution isEqual: @"HB Left"]) {
        NSString *orientationFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationFile.txt"];
        NSString *newOrientation = @"90";
        [newOrientation writeToFile:orientationFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *orientationSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"orientationSelection.txt"];
        NSString *newOrientationSelection = @"2";
        [newOrientationSelection writeToFile:orientationSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    
}
- (IBAction)audioOnOff:(UISwitch *)sender {
    if (sender.on){
        NSString *audioFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioFile.txt"];
        NSString *newAudio = @"yes";
        [newAudio writeToFile:audioFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *audioSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioSelection.txt"];
        NSString *newAudioSelection = @"on";
        [newAudioSelection writeToFile:audioSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        NSString *audioFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioFile.txt"];
        NSString *newAudio = @"no";
        [newAudio writeToFile:audioFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *audioSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"audioSelection.txt"];
        NSString *newAudioSelection = @"off";
        [newAudioSelection writeToFile:audioSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)screenRecorderDidStartRecording:(CSScreenRecorder *)recorder
{
    NSLog(@"KDD, DID START");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mpView setHidden:YES];
        
        /*[self.labelTime setText:@""];
        [self.labelTime setHidden:NO];*/
        //_labelTime.hidden = false;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    });
}

- (void)screenRecorderDidStopRecording:(CSScreenRecorder *)recorder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.mpView setHidden:NO];
        
        //[self.labelTime setHidden:YES];
        //_labelTime.hidden = true;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    });
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)dismissKeyboard
{
    [_videoName resignFirstResponder];
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
