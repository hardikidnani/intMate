//
//  EditFriendsTableViewController.m
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "EditFriendsTableViewController.h"
#import "MSCellAccessory.h"
#import<Parse/Parse.h>

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

UIColor *disclosureColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self isnetworkIsWorking])
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    

    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    BOOL isInCache = [query hasCachedResult];
    NSLog(@"print : %d",isInCache);
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    //BOOL isInCache = [query hasCachedResult];
   // NSLog(@"print : %d",isInCache);
    //NSLog(@"Query results : %@",query);
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error)
     
     {
     
            if (error)
            {
            
                NSLog(@"Error: %@ %@", error,[error userInfo]);
            }
            else{
            
                self.allUsers = objects;
                [self.tableView reloadData];
               
            
            
            }
         
     }];
    
    self.currentUser = [PFUser currentUser];
    disclosureColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.allUsers count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self isFriend:user]){
        
    
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    }
    else{
      //  cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    if ([self isFriend:user]){
    
        cell.accessoryView = nil;
       //remove checkmark
        //cell.accessoryType = UITableViewCellAccessoryNone;
        
        //remove arrayof friends
        for(PFUser *friend in self.friends)
        {
            
            if([friend.objectId isEqualToString:user.objectId]){
                [self.friends removeObject:friend];
                break;
                
            }
            
        }
        
        //remove from backend
        
                  [friendsRelation removeObject:user];
            }
    else{
        
        
           // cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
            [self.friends addObject:user];
            [friendsRelation addObject:user];
        }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error){
            NSLog(@"Error %@ %@",error,[error userInfo]);
        }
        
        
        
    }];

    
    
}

#pragma mark-Helper Methods
-(BOOL)isFriend:(PFUser *)user{
  
    for(PFUser *friend in self.friends)
    {
    
        if([friend.objectId isEqualToString:user.objectId]){
            return YES;
        }
    
    }
    return NO;

}

@end
