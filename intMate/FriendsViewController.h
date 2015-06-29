//
//  FriendsViewController.h
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface FriendsViewController : UITableViewController
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSArray *friends;
@end
