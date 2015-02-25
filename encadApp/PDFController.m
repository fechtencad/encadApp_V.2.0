//
//  PDFController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "PDFController.h"
#import "AuditionDatesController.h"
#import "AuditionSignInController.h"
#import "EventSignInController.h"

@interface PDFController ()<UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarButton;
@property (nonatomic, strong) NSString *serverPath;
@property (nonatomic, strong) NSString *pdfURLString;
@property (nonatomic, strong) NSString *datasheetName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signingButton;

- (IBAction)pressedToolbarButton:(id)sender;

@end

@implementation PDFController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background
    if(_audition || _auditionDate)
        _backgroundPicture=@"background_audition_bird.png";
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_backgroundPicture]];
    imageView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [_pdfWebView setAlpha:1.0];
    
    [self.view insertSubview:imageView belowSubview:_pdfWebView];
    
    //set title
    if(_audition)
        self.navigationItem.title=_audition.name;
    else
        self.navigationItem.title=_auditionDate.schulungs_name;
    
    //get server path
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _serverPath = [defaults stringForKey:@"serverPath"];
    
    //initWebView
    [self initWebView];
    [_pdfWebView setContentScaleFactor:5.0f];
    
    //init button
    [self initButton];
    if(_audition){
        self.navigationItem.rightBarButtonItem=nil;
    }
}

-(void)initWebView{
    if(_audition)
        _datasheetName=_audition.datenblatt_name;
    if (_auditionDate)
        _datasheetName=_auditionDate.datenblatt_name;
    if (_event)
        _datasheetName=_event.name;
    if(_audition || _auditionDate)
     _pdfURLString = [[[_serverPath stringByAppendingString:@"pdf/datasheet/" ] stringByAppendingString: _datasheetName] stringByAppendingString:@".pdf"];
    if(_event)
        _pdfURLString = [[[_serverPath stringByAppendingString:@"pdf/agenda/" ] stringByAppendingString: _datasheetName] stringByAppendingString:@".pdf"];
    NSURL *theURL = [NSURL URLWithString:_pdfURLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:theURL];
    
    [_pdfWebView loadRequest:request];
}

-(void)initButton{
    if(_audition)
       [_toolbarButton setTitle:@"Schulungstermine anzeigen"];
    else
        [_toolbarButton setTitle:@"Anmelden"];
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

- (IBAction)pressedToolbarButton:(id)sender {
    if(_audition){
        AuditionDatesController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"auditionDates"];
        vc.theSubPredicate = [NSPredicate predicateWithFormat:@"schulungs_name = %@",_audition.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_auditionDate){
        AuditionSignInController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"auditionSignIn"];
        vc.auditionDate = _auditionDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_event){
        EventSignInController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventSignIn"];
        vc.event=_event;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
