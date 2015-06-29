//
//  InboxViewController.h
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController
@property(nonatomic,strong) NSArray *messages;
@property(nonatomic,strong) PFObject *selectedMessage;
@property(nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
- (IBAction)logut:(id)sender;


@end
