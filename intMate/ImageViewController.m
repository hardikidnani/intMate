//
//  ImageViewController.m
//  intMate
//
//  Created by Hardik Idnani on 8/06/2015.
//  Copyright (c) 2015 Hardik Idnani. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self isnetworkIsWorking])
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Your connection appear to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    

    // Do any additional setup after loading the view.
    
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc]initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@",senderName];
    self.navigationItem.title = title;
}
-(BOOL)isnetworkIsWorking{
    
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: @"http://www.google.com"]];
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    
    
    if(serverOutput.length>0){
        
        return true;
        
        
    } else {
        return false;
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self respondsToSelector:@selector(timeout)]){
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    
    }
    else{
    
        NSLog(@"Error: Selector Missing");
    
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-Helper Methods
-(void)timeout {
   
    [self.navigationController popViewControllerAnimated:YES];

}
/*
#pragma mark - Navigat

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
