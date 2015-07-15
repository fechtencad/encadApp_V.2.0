//
//  UniversalWebViewController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 20.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "UniversalWebViewController.h"

@interface UniversalWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation UniversalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title
    self.navigationItem.title = _urlString;
    
    //UIWebView settings
    NSURL *loadURL = [NSURL URLWithString:[_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:loadURL];
    [self.webView loadRequest:request];
    
    //Activity Indicator settings
    self.activityIndicator.hidesWhenStopped=YES;
    self.activityIndicator.color = [UIColor blueColor];
    [self.activityIndicator startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(loading)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loading{
    if (!_webView.loading)
        [self.activityIndicator stopAnimating];
    else
        [self.activityIndicator startAnimating];
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
