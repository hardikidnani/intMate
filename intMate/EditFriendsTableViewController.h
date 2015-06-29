//
//  EditFriendsTableViewController.h
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *allUsers;
@property (nonatomic,strong) PFUser *currentUser;
@property (nonatomic,strong) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;
@end
