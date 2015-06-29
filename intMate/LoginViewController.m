//
//  LoginViewController.m
//  intMate
//
//  Created by Hardik Idnani on 23/05/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.hidesBackButton = YES; //hide the back button
    // Do any additional setup after loading the view.
        
   if (![self isnetworkIsWorking])
    {
    
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        [alert show];
    }
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

}


- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username, password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }

    else{
          [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            
                                            if (error) {
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alertView show];
                                            }
                                            else {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }

                                        
                                        
                                        }];

    
    
    }
        
   }
#pragma -UITextField delegate methods


  
@end
