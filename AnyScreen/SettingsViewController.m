//
//  SettingsViewController.m
//  PixlRec
//
//  Created by Joseph on 6/3/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];*/
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

}
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
- (IBAction)closeButton:(id)sender {
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
    if ([fps isEqual: @"29.7"]) {
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = @"29.7";
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"0";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([fps isEqual: @"30"]) {
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = @"30";
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"1";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([fps isEqual: @"60"]) {
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = @"60";
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"2";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if ([fps isEqual: @"Custom"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom FPS" message:@"Please Input Your Custom FPS" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField *noteText = [alertView textFieldAtIndex:0];
        NSString *note = noteText.text;
        NSString *fpsFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsFile.txt"];
        NSString *newFPS = note;
        [newFPS writeToFile:fpsFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *newFPSSelection = @"3";
        [newFPSSelection writeToFile:fpsSelectionFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        NSString *fpsSelectionFile = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"fpsSelection.txt"];
        NSString *fpsSelection = [NSString stringWithContentsOfFile:fpsSelectionFile encoding:NSUTF8StringEncoding error:nil];
        int fpsSelectionReal = [fpsSelection intValue];
        _fpsSelector.selectedSegmentIndex = fpsSelectionReal;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
