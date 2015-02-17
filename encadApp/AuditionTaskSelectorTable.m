//
//  AuditionTaskSelectorTable.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 12.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionTaskSelectorTable.h"
#import "AudtionTaskTableViewCell.h"

@interface AuditionTaskSelectorTable ()

@property (strong) NSArray *titles;
@property (strong) NSArray *descriptions;
@property (strong) NSArray *pictures;
@property (strong) NSArray *backgrounds;
@property (strong) NSArray *segues;

@end

@implementation AuditionTaskSelectorTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title
    self.navigationItem.title=@"Schulungen";
    
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_audition_bird.png"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.tableView.backgroundView = imageView;
    
    //Set Menue Items
    _segues = @[@"auditionDates",
                @"auditionTable"];
    
    _titles=@[@"Termine",
              @"Schulungen"];
    
    _descriptions=@[@"Sehen Sie hier alle Schulungstermine der encad consulting und senden sie gleich eine Anfrage an uns.",
                    @"Durchstöbern Sie unser Schulungsportfolio und finden sie die passende Schulung für Sie."];
    
    _pictures=@[@"catia_screen_bird.png",
                @"datasheet_bird.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"auditionTaskCell";
    AudtionTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell.titleLabel setText:_titles[indexPath.row]];
    [cell.descriptionLabel setText:_descriptions[indexPath.row]];
    [cell.theImageView setImage:[UIImage imageNamed:_pictures[indexPath.row]]];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_backgrounds[indexPath.row]]];
//    [imageView setFrame:cell.frame];
//    [imageView setContentMode:UIViewContentModeScaleAspectFill];
//    cell.backgroundView =imageView;
    
    return cell;
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
