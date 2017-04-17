//
//  MakeVideoViewController.m
//  PixlRec
//
//  Created by Joseph on 26/2/17.
//  Copyright © 2017 Joseph Shenton. All rights reserved.
//

#import "MakeVideoViewController.h"

@interface MakeVideoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation MakeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * result = NULL;
    NSError *err = nil;
    NSURL * urlToRequest = [NSURL   URLWithString:@"https://pixlrec.com/PixlRecRemote/version.txt"];
    if(urlToRequest)
    {
        result = [NSString stringWithContentsOfURL: urlToRequest
                                          encoding:NSUTF8StringEncoding error:&err];
        _versionLabel.text = result;
    }
    
    if(!err){
        NSLog(@"Result::%@",result);
    }
}
- (IBAction)closePopup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
