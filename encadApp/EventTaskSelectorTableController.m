//
//  EventTaskSelectorTableController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "EventTaskSelectorTableController.h"
#import "EventTaskSelectorTableViewCell.h"

@interface EventTaskSelectorTableController ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *descriptions;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, strong) NSArray *segues;

@end

@implementation EventTaskSelectorTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_event_bird.png"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.tableView.backgroundView = imageView;
    
    //configure data
    _titles = @[@"Veranstaltungen",
                @"Webinare"];
    _descriptions=@[@"Informieren Sie sich über die kommenden Veranstaltungen.",
                    @"Sehen Sie wann eines unserer nächsten Webinare ist."];
    _pictures=@[@"",
                @""];
    
    _segues=@[@"events",
              @"webinars"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"eventTaskSelectorCell";
    EventTaskSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.titleLabel.text = _titles[indexPath.row];
    cell.descriptionLabel.text = _descriptions[indexPath.row];
    cell.eventImageView.image=[UIImage imageNamed:_pictures[indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:_segues[indexPath.row]] animated:YES];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
