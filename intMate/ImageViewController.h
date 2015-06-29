//
//  ImageViewController.h
//  intMate
//
//  Created by Hardik Idnani on 8/06/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic,strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
