//
//  CameraViewController.m
//  intMate
//
//  Created by Hardik Idnani on 25/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "MSCellAccessory.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

UIColor *disclosuresColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self isnetworkIsWorking])
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    

    self.recipients = [[NSMutableArray alloc]init];
    disclosuresColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    //to set up camera
    
    
    
    
    }
-(BOOL)isnetworkIsWorking{
    
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: @"http://www.google.com"]];
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    
    
    // if([serverOutput isEqualToString:@"internet is working"]){
    if(serverOutput.length>0){
        
        return true;
        
        
    } else {
        return false;
    }
    
}



//shifting from view did load appear to view will apppear would help to display the photo at first in camera
-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query= [self.friendsRelation query];
   [query orderByAscending:@"username"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    BOOL isInCache = [query hasCachedResult];
    NSLog(@"print : %d",isInCache);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (error)
        {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else{
            
            self.friends = objects;
            [self.tableView reloadData];
            
        }
        
    }];
    //[PFObject pinAllInBackground:_friends];
    if(self.image == nil && [self.videoFilePath length]==0){
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.videoMaximumDuration = 10;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;}
    else{
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    [self presentViewController:self.imagePicker  animated:NO completion:nil];
    //[self.view.window.rootViewController presentViewController:self.imagePicker animated:YES completion:nil];
        
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self.recipients containsObject:user.objectId]){
    
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosuresColor];
        }
    else{
    
        //cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -Image pciker controller delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
    //A photo was taken or selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (self.imagePicker.sourceType ==UIImagePickerControllerSourceTypeCamera){
        //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        
                }
     }
    else{
            //A video was taken/selected
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
           //save the video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil,nil,nil);
            }
        }
    
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    if (cell.accessoryView == nil){
    
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosuresColor];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
        }
    else{
    
       cell.accessoryView = nil;
       // cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
        //NSLog(@"%@",self.recipients);
    
    }

}
#pragma  - Ibactions

- (IBAction)cancel:(id)sender {
    
    [self reset];
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)send:(id)sender {
    
    if (self.image == nil && [self.videoFilePath length]==0){
    
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Try again" message:@"Please capture or select a photo or video to share !" delegate:self cancelButtonTitle:@"OK !" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else{
    
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    
    }
}


#pragma mark - Helper Methods

-(void) uploadMessage{
    //Check if an image or video
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    if(self.image != nil){
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
    }
    else{
    
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error){
        
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error occured" message:@"Please try to send the file again!" delegate:self cancelButtonTitle:@"OK !" otherButtonTitles:nil];
            [alertView show];
        
        
        }
        else
        {
        
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser]username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                
                if (error){
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error occured" message:@"Please try to send the file again!" delegate:self cancelButtonTitle:@"OK !" otherButtonTitles:nil];
                    [alertView show];
                    
                    
                }
                else{
                
                        //everything is successful
                        [self reset];
                }
            }];
        }
        
    }];
    
    //If image, shrink it
    //Upload the file itself
    //Upload the messgae details
    

}
- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
