//
//  CreditTableViewController.m
//  PixlRec
//
//  Created by Anthony Agatiello on 2/18/15.
//  Allowed to be used by Joseph Shenton for PixlRec
//  I have written permission to be able to use this.
//
//

#import <Social/Social.h>
#import "CreditTableViewController.h"
#import "UIAlertView+RSTAdditions.h"
#import "UpdateViewController.h"
#import "FXBlurView.h"

@implementation CreditTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self openTwitterAccountWithUsername:@"JosephShenton"];
        }
        
        if (indexPath.row == 1) {
            [self openTwitterAccountWithUsername:@"AAgatiello"];
        }
        
        if (indexPath.row == 2) {
            [self openTwitterAccountWithUsername:@"XinDawn"];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UpdateViewController *updateViewController = [[UpdateViewController alloc] init];
            [self.navigationController pushViewController:updateViewController animated:YES];
        }
    }

    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height * 4)];
            [blurView setDynamic:YES];
            blurView.tintColor = [UIColor clearColor];
            blurView.blurRadius = 8;
            [self.view addSubview:blurView];
            
            UIAlertView *bugAlert = [[UIAlertView alloc] initWithTitle:@"Report Bug" message:@"Thank you for using PixlRec and giving us feedback so we can make it even better! Please tell us the bug you are experiencing via Twitter or E-Mail as specifically as possible! Are you sure you want to report a bug?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Twitter", @"E-Mail", nil];
            
            [bugAlert showWithSelectionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [blurView removeFromSuperview];
                }
                if (buttonIndex == 1) {
                    //Twitter
                    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [tweetSheet setInitialText:@"@Joseph Shenton PixlRec Bug: *remove this text, and enter description here*"];
                    [self presentViewController:tweetSheet animated:YES completion:nil];
                    [blurView removeFromSuperview];
                }
                if (buttonIndex == 2) {
                    //E-Mail
                    NSString *subject = @"PixlRec Bug";
                    NSArray *recipients = [NSArray arrayWithObject:@"bugs@pixlrec.com"];
                    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                    mc.mailComposeDelegate = self;
                    [mc setSubject:subject];
                    [mc setMessageBody:@"" isHTML:NO];
                    [mc setToRecipients:recipients];
                    [self presentViewController:mc animated:YES completion:nil];
                    [blurView removeFromSuperview];
                }
            }];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"E-Mail cancelled.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"E-Mail saved.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"E-Mail sent.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"E-Mail send failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)openTwitterAccountWithUsername:(NSString *)username {
    NSString *scheme = @"";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) // Twitter
    {
        scheme = [NSString stringWithFormat:@"twitter://user?screen_name=%@",username];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) // Tweetbot
    {
        scheme = [NSString stringWithFormat:@"tweetbot:///user_profile/%@",username];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) // Twitterrific
    {
        scheme = [NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@",username];
    }
    else
    {
        scheme = [NSString stringWithFormat:@"http://twitter.com/%@",username];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
}

@end
