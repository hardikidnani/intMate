//
//  FriendsViewController.m
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "FriendsViewController.h"
#import <Parse/Parse.h>
#import "EditFriendsTableViewController.h"
#import "GravatarUrlBuilder.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![self isnetworkIsWorking])
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    

    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query= [self.friendsRelation query];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    BOOL isInCache = [query hasCachedResult];
    NSLog(@"print : %d",isInCache);
    
        //[query fromLocalDatastore];
    //[query orderByAscending:@"username"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //BOOL isInCache = [query hasCachedResult];
    //NSLog(@"print : %d",isInCache);

   // query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
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

    
    
   // NSArray *objects = [query findObjects]; // Online PFQuery results
    //[PFObject pinAllInBackground:objects];
    //[query fromLocalDatastore];


    //PFObject *users = [PFObject objectWithClassName:@"User"];
    //[PFObject pinAllInBackground:_friends];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
    if([segue.identifier isEqualToString:@"showEditFriends"]){
        EditFriendsTableViewController *viewController = (EditFriendsTableViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    
    }
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    
        //get email
        NSString *email = [user objectForKey:@"email"];
        //create md5 hash
        NSURL *gravatarUrl = [GravatarUrlBuilder getGravatarUrl:email];
        //request image from gravatar
        NSData *imageData = [NSData dataWithContentsOfURL:gravatarUrl];
        if (imageData != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{cell.imageView.image = [UIImage imageWithData:imageData];
            [cell setNeedsLayout];
        });
            
        }
    });
    
    cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    return cell;
    
    
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark; //TO GIVE CHECKMARK
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    [friendsRelation addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error){
            NSLog(@"Error %@ %@",error,[error userInfo]);
        }
        
        
        
    }];
}
*/


@end
