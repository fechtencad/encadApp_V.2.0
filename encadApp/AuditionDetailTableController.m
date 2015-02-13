//
//  AuditionDetailTableController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 13.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionDetailTableController.h"
#import "AuditionDatesController.h"

@interface AuditionDetailTableController ()<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDatasheet;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAudtionDates;
@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (nonatomic, strong) NSString *pdfURL;

@end

@implementation AuditionDetailTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Title
    self.navigationItem.title = _audition.name;
    
    //TODO: change server path to NSUserDefaults
    //Set WebView
    _pdfURL = [[@"http://www.encad-akademie.de/pdf/datasheet/" stringByAppendingString:_audition.datenblatt_name] stringByAppendingString:@".pdf"];
    NSURL *theURL = [NSURL URLWithString:_pdfURL];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    [_pdfWebView loadRequest:theRequest];
    
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
            
        default:
            break;
    }
}

//TODO: implement the controller
-(void)openDocumentInteractionController{
    //download file
    
    //setup controller
//    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:url];
//    
//    [controller setDelegate:self];
//    
//    [controller presentPreviewAnimated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AuditionDatesController *vc = [segue destinationViewController];
    vc.theSubPredicate = [NSPredicate predicateWithFormat:@"schulungs_name = %@",_audition.name];
}


@end
