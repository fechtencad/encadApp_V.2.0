//
//  ImpressumController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 23.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "ImpressumController.h"

@interface ImpressumController ()

@end

@implementation ImpressumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title
    self.navigationItem.title=@"Impressum";
   
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_aboutus.png"]];
    imageView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:imageView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
