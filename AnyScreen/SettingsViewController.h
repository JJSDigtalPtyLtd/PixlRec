//
//  SettingsViewController.h
//  PixlRec
//
//  Created by Joseph on 6/3/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *audioOnOffSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *resolutionSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fpsSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationSelector;
@property (weak, nonatomic) IBOutlet UISwitch *audioSwitch;

@end
