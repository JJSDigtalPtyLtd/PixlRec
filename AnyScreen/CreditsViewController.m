//
//  CreditsViewController.m
//  PixlRec
//
//  Created by Joseph on 21/2/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *developerLabel;
@property (weak, nonatomic) IBOutlet UILabel *airplaySDKDevLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiDesignerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gfxDesignerLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialThanksLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeAdsBtn;

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSURL *url = [NSURL URLWithString:@"https://328949riejkfdh2idiewd9huiesf923erhfhuf9321232982.bitballoon.com/N972839784987SJKDFHKJ29W892.txt"];
    NSError* error;
    NSString *noAdsList = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    if ([noAdsList rangeOfString:udid].location == NSNotFound) {
        NSLog(@"Can buy removal!");
        _removeAdsBtn.title = @"Remove Ads";
    } else {
        NSLog(@"Already purchased removal!");
        _removeAdsBtn.title = @"No Ads";
    }

    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];*/
    [self.view setMultipleTouchEnabled:YES];

}
- (IBAction)closePopup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)removeAds:(id)sender {
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSURL *url = [NSURL URLWithString:@"https://paypal.me/JJSDigital/1.99"];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Remove Ads" message: @"Please copy this code and put it in the notes section of paypal. Please pay as friends and family. No refunds will be issued for failure to follow instructions." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = udid;
        textField.placeholder = @"UDID";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * udid = textfields[0];
        NSLog(@"%@",udid.text);
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:url options:@{} completionHandler:nil];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
