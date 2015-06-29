//
//  InboxViewController.m
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"
#import "MSCellAccessory.h"
#import <Parse/Parse.h>

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.moviePlayer = [[MPMoviePlayerController alloc]init];
    PFUser *currentUser=[PFUser currentUser];
    if(currentUser){
        NSLog(@"Current user: %@",currentUser.username);
        }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
    
    
    
  
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

- (void) viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    if (![self isnetworkIsWorking])
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        //[self queryLocalDataStore];
    }

    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self retrieveMessages];
  
    
    
    
    //[PFObject pinAllInBackground:_messages];
}

/*-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        
        if(error)
        {
            NSLog(@"Error : %@ %@",error,[error userInfo]);
        
        }
        else{
        
             // We found messages
            self.messages = objects;
            [self.tableView reloadData]; 
            NSLog(@"Retrieved %d messages",[self.messages count]);
        }
    
 
    }];
    
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
   // [message saveEventually];
     //[PFObject pinAllInBackground:_messages];
    //[PFObject pinAllInBackground:messages];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    /*[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The object has been saved.");
        } else {
            // There was a problem, check error.description
        }
    }];*/
    
    
    UIColor *disclosureColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
    
    NSString *fileType = [message objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]){
    
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else{
       
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    
    }
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]){
        
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else{
        //file tpe is video
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        //Add it to the view controller
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    //Delete It
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients : %@", recipientIds);
    if ([recipientIds count]== 1)
    {
    //Last recipient deleted
        
        [self.selectedMessage deleteInBackground];
    }
    else
    {
        //Remove the recipient and save it
        [recipientIds removeObject:[[PFUser currentUser]objectId] ];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
        
    }
}


- (IBAction)logut:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES]; //used for hiding the bottom tab bar
    
    }
    else if([segue.identifier isEqualToString:@"showImage"]){
    
       [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
    
    }

}

#pragma - Hepler methods
- (void)retrieveMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    //BOOL isInCache = [query hasCachedResult];
    //NSLog(@"print : %d",isInCache);

        // prevents error when running for first time in a while
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"error %@ %@", error, [error userInfo]);
            } else {
                self.messages = objects;
                [self.tableView reloadData];
                NSLog(@"Got %lu messages", (unsigned long)[self.messages count]);
                query.cachePolicy = kPFCachePolicyCacheThenNetwork;
                BOOL isInCache = [query hasCachedResult];
                NSLog(@"print : %d",isInCache);

               
            }
           
            
            if ([self.refreshControl isRefreshing]){
               
                [self.refreshControl endRefreshing];
              
            }
        }];
       
    }
}


@end
