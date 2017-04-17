//
//  InformationViewController.m
//  PixlRec
//
//  Created by Joseph on 19/12/2016.
//  Copyright © 2016 Joseph Shenton. All rights reserved.
//

#import "InformationViewController.h"

@implementation InformationViewController
- (void)viewDidLoad {
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *totalVersion = [NSString stringWithFormat:@"%@ %@", appVersion, bundleVersion];

    _Version.text = totalVersion;
}
@end
