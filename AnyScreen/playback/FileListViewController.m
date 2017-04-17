//
//  FileListViewController.m
//  AnyScreen
//
//  Created by pcbeta on 16/5/13.
//  Copyright © 2016年 xindawn. All rights reserved.
//

#import "FileListViewController.h"
#import "IDFileManager.h"
#import "AVPlayerViewController.h"
#import "FileListTableViewCell.h"
#import "CSScreenRecorder.h"

@import MediaPlayer;

@interface FileListViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *_folderItems;
    NSMutableArray *_inHandleItems;
    
    int selectedRow;
}

@property (weak, nonatomic) IBOutlet NSString *file;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _inHandleItems = [[NSMutableArray alloc] init];
    
    /*self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];*/
}

- (void)reloadFileList
{
    _folderItems = nil;
    _folderItems = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[IDFileManager inDocumentsDirectory:@""] error:nil] mutableCopy];
    _folderItems = [NSMutableArray arrayWithArray:[_folderItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"]]];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadFileList];
    
    [self.tableView reloadData];
    
     self.tableView.editing = NO;
    self.toolBar.hidden = !self.tableView.editing;

//    NSLog(@"kdd: view did appear .... 111");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fielAdded:) name:kFileAddedNotification object:nil];
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fielAdded:(NSNotification *)notification
{
    NSLog(@"kdd, fielAdded........");
    [self reloadFileList];
    [self.tableView reloadData];
}



- (void)dealloc {
    _folderItems = nil;
    _inHandleItems = nil;
    NSLog(@"kdd: dealloc for FileListViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSInteger c = [_folderItems count];
    
    if(c == 0)
    {
        [self.editBtn setEnabled:NO];
//        self.tableView.editing = NO;
        self.toolBar.hidden = YES;
    }
    else
    {
        [self.editBtn setEnabled:YES];
    }
   
    return c;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_folderItems objectAtIndex:indexPath.row];
 //   cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    NSString *fileName = [_folderItems objectAtIndex:indexPath.row];
    if ([fileName  isEqual: @"fpsFile.txt"] || [fileName  isEqual: @"fpsSelection.txt"] || [fileName  isEqual: @"heightFile.txt"] || [fileName  isEqual: @"widthFile.txt"] || [fileName  isEqual: @"resolutionSelection.txt"] || [fileName  isEqual: @"resolutionSelection.tzt"] || [fileName  isEqual: @"orientationSelection.txt"] || [fileName  isEqual: @"orientationSelection.tzt"] || [fileName  isEqual: @"orientationFile.txt"] || [fileName  isEqual: @"audioSelection.txt"] || [fileName  isEqual: @"audioFile.txt"]) {
        NSString *filePath = [IDFileManager inDocumentsDirectory:fileName];
        NSLog(@"FNAME:%@", fileName);
        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];

        cell.detailTextLabel.text = [IDFileManager humanReadableStringFromBytes:size];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.hidden = true;

    } else {
        NSString *filePath = [IDFileManager inDocumentsDirectory:fileName];
        NSLog(@"FNAME:%@", fileName);
        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        cell.detailTextLabel.text = [IDFileManager humanReadableStringFromBytes:size];
    }
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Share on PixlShare",
                                @"Share on YouTube",
                                @"Share on Twitter",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
        _file = _inHandleItems;
        [_inHandleItems removeAllObjects];
        //[_inHandleItems removeObjectAtIndex:indexPath.row];
        [self reloadFileList];
        [self.tableView reloadData];
        [tableView reloadData]; // tell table to refresh now
        [self.tableView setEditing:NO];
    }];
    shareAction.backgroundColor = [UIColor colorWithRed:0.98 green:0.50 blue:0.45 alpha:1.0];
    
    UITableViewRowAction *exportAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Export" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        [_inHandleItems addObject:[_folderItems objectAtIndex:indexPath.row]];
        for (NSString * theStr in _inHandleItems) {
            NSLog(@"%@:",theStr);
            NSString *filePath = [IDFileManager inDocumentsDirectory:theStr];
            NSURL* url = [NSURL fileURLWithPath:filePath];
            
            [IDFileManager copyFileToCameraRoll:url didFinishcompledBlock:nil];
            NSString *message = @"Video Saved To Camera Roll.";
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            int duration = 3; // in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
        [_inHandleItems removeAllObjects];
        //[_inHandleItems removeObjectAtIndex:indexPath.row];
        [self reloadFileList];
        [self.tableView reloadData];
        [tableView reloadData]; // tell table to refresh now
        [self.tableView setEditing:NO];
    }];
    exportAction.backgroundColor = [UIColor colorWithRed:0.46 green:0.28 blue:0.64 alpha:1.0];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [_inHandleItems addObject:[_folderItems objectAtIndex:indexPath.row]];
        for (NSString * theStr in _inHandleItems) {
            NSLog(@"%@:",theStr);
            NSString *filePath = [IDFileManager inDocumentsDirectory:theStr];
            NSURL* url = [NSURL fileURLWithPath:filePath];
            [IDFileManager removeFile:url];
        }
        
        [_inHandleItems removeAllObjects];
        //[_inHandleItems removeObjectAtIndex:indexPath.row];
        [self reloadFileList];
        [self.tableView reloadData];
        [tableView reloadData]; // tell table to refresh now
    }];
    
    return @[deleteAction, exportAction/*, shareAction*/];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self PixlShare];
                    [self uploadFileToServer:_file];
                    break;
                case 1:
                    [self YouTubeShare];
                    break;
                case 2:
                    [self TwitterShare];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(NSString *)uploadFileToServer:(NSString *)fileName

{
    
    /* creating path to document directory and appending filename with extension */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData *file1Data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSString *urlString = @"https://share.pixlrec.com/upload.php";
    
    /* creating URL request to send data */
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"—————————14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /* adding content as a body to post */
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\".%@\"\r\n",[fileName stringByDeletingPathExtension],[fileName pathExtension]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n–%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:file1Data]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n–%@–\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] ;
    
    return returnString;
    
}

- (void)PixlShare {
    
    NSString *message = @"Video Shared to PixlShare.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 3; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)YouTubeShare {
    NSString *message = @"Video Shared to YouTube.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 3; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)TwitterShare {
    NSString *message = @"Video Shared to Twitter.";
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 3; // in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [_inHandleItems addObject:[_folderItems objectAtIndex:indexPath.row]];
        for (NSString * theStr in _inHandleItems) {
            NSLog(@"%@:",theStr);
            NSString *filePath = [IDFileManager inDocumentsDirectory:theStr];
            NSURL* url = [NSURL fileURLWithPath:filePath];
            [IDFileManager removeFile:url];
        }
        
        [_inHandleItems removeAllObjects];
        //[_inHandleItems removeObjectAtIndex:indexPath.row];
        [self reloadFileList];
        [self.tableView reloadData];
        [tableView reloadData]; // tell table to refresh now
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"\n\nkdd:commitEditingStyle\n\n");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.isEditing)
    {
        [_inHandleItems addObject:[_folderItems objectAtIndex:indexPath.row]];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectedRow = indexPath.row;
    
        [self delayMethod:selectedRow];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if(self.tableView.isEditing)
    {
        [_inHandleItems removeObject:[_folderItems objectAtIndex:indexPath.row]];
   }
    
}


- (void)delayMethod:(int)index
{
     [self performSegueWithIdentifier:@"goVideo" sender:self];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"goVideo"]){
        AVPlayerViewController *destViewController = segue.destinationViewController;
        
        NSString *fileName = [_folderItems objectAtIndex:selectedRow];
        NSString *filePath = [IDFileManager inDocumentsDirectory:fileName];

        destViewController.stringName = filePath;
        destViewController.movieName = fileName;
    }
}

- (IBAction)onEditButton:(id)sender
{
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.tableView.editing = !self.tableView.editing;
    
    [_inHandleItems removeAllObjects];
    
     self.toolBar.hidden = !self.tableView.editing;
}

- (IBAction)onSelectAllButton:(id)sender
{
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [_inHandleItems addObject:[_folderItems objectAtIndex:indexPath.row]];
    }
}

- (IBAction)onDeleteButton:(id)sender
{
    if(self.tableView.isEditing)
    {
        for (NSString * theStr in _inHandleItems) {
            NSLog(@"%@:",theStr);
            NSString *filePath = [IDFileManager inDocumentsDirectory:theStr];
            NSURL* url = [NSURL fileURLWithPath:filePath];
            [IDFileManager removeFile:url];
        }
        
        [_inHandleItems removeAllObjects];
        
        [self reloadFileList];
        [self.tableView reloadData];
    }
}


- (IBAction)onCopyButton:(id)sender
{
    if(self.tableView.isEditing)
    {
        for (NSString * theStr in _inHandleItems) {
            NSLog(@"%@:",theStr);
            NSString *filePath = [IDFileManager inDocumentsDirectory:theStr];
            NSURL* url = [NSURL fileURLWithPath:filePath];

            [IDFileManager copyFileToCameraRoll:url didFinishcompledBlock:nil];
            NSString *message = @"Video Saved To Camera Roll.";
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
        }
        
    }

}
@end
