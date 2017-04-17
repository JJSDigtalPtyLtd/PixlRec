//
//  SetupRecordingViewController.h
//  PixlRec
//
//  Created by Joseph on 21/3/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef kern_return_t SpringBoardServicesReturn;

@interface SetupRecordingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *audioOnOffSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *resolutionSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fpsSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationSelector;
@property (weak, nonatomic) IBOutlet UISwitch *audioSwitch;
@end
