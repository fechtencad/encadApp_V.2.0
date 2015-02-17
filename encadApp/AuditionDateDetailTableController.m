//
//  AuditionDateDetailTableController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 17.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionDateDetailTableController.h"
#import "AuditionSignInController.h"

@interface AuditionDateDetailTableController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (nonatomic, strong) NSString *pdfURL;

@end

@implementation AuditionDateDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set title
    self.navigationItem.title=_auditionDate.schulungs_name;
    
    //set server path
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serverPath = [defaults stringForKey:@"serverPath"];
    
    //Set WebView
    _pdfURL = [[[serverPath stringByAppendingString:@"pdf/datasheet/"] stringByAppendingString:_auditionDate.datenblatt_name] stringByAppendingString:@".pdf"];
    NSURL *theURL = [NSURL URLWithString:_pdfURL];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    [_pdfWebView loadRequest:theRequest];
    [_pdfWebView setAlpha:0.2f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self openDocumentInteractionController];
            break;
        case 1:
            [self prepareForAuditionSignInSegue];
            
        default:
            break;
    }
}

-(void)openDocumentInteractionController{
    
    // Get the PDF Data from the url in a NSData Object
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[                                                             NSURL URLWithString:_pdfURL]];
    
    // Store the Data locally as PDF File
    NSString *resourceDocPath = [[NSString alloc] initWithString:[
                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                  stringByAppendingPathComponent:@"Documents"
                                                                  ]];
    
    NSString *filePath = [resourceDocPath
                          stringByAppendingPathComponent:@"tmpDatasheet.pdf"];
    [pdfData writeToFile:filePath atomically:YES];
    
    
    // Now create Request for the file that was saved in your documents folder
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //setup controller
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    [controller setDelegate:self];
    
    [controller presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

-(void)prepareForAuditionSignInSegue{
    AuditionSignInController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"auditionSignIn"];
    vc.auditionDate = _auditionDate;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
