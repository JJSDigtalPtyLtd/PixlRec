//
//  LegalViewController.m
//  PixlRec
//
//  Created by Joseph on 10/3/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "LegalViewController.h"
#include <sys/time.h>
#import <dlfcn.h>

@interface LegalViewController ()
@property (weak, nonatomic) IBOutlet UITextView *legalText;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation LegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"legal" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _legalText.text = content;

}
- (IBAction)agreeMan:(id)sender {
    [self agree];
}
- (IBAction)disagreeMan:(id)sender {
    [self disagree];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _toolbar.hidden = false;
}
- (void)agree {
    NSString *welcome = @"yes";
    NSString *welcomePath = [[self applicationDocumentsDirectory].path
                                 stringByAppendingPathComponent:@"welcomeFile.txt"];
    [welcome writeToFile:welcomePath atomically:YES
                    encoding:NSUTF8StringEncoding error:nil];
    NSString *message = @"App will crash in 3 seconds please relaunch.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 3; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
        exit(0);
    });
}
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
- (void)disagree {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
