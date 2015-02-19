//
//  HomeScreenTable.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 11.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "HomeScreenTable.h"
#import "HomeScreenTableViewCell.h"

@interface HomeScreenTable ()

@property (strong) NSArray* labelTitles;
@property (strong) NSArray* pictureNames;
@property (strong) NSArray* labelDescriptions;
@property (strong) NSArray* segues;

@end

@implementation HomeScreenTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set Title
    self.navigationItem.title=@"Home";
    
    
    //Set Menue Items
    _labelTitles = @[
                     @"Schulungen",
                     @"Veranstaltungen",
                     @"Hotline",
                     @"Wir über uns",
                     @"Anfahrt",
                     @"Impressum"
                     ];
    _labelDescriptions=@[
                         @"Hier können Sie die Schulungen der encad consulting einsehen und bei Interresse eine Anfrage zur Teilnahme versenden.",
                         @"Sehen Sie hier, welche neuen Veranstaltungen es von der encad consulting gibt und melden Sie sich gleich an!",
                         @"Sie haben ein Problem oder eine Frage? Schreiben Sie uns über dieses Tool eine Mail mit Ihrem Anliegen.",
                         @"Erfahren Sie, wer die encad consulting ist, und was sie macht.",
                         @"Sie wollen uns vor Ort besuchen, kennen aber den Weg nicht? Kein Problem...",
                         @"Anschrift und Kontaktdaten unserer Geschäftstelle."
                         ];
    _pictureNames = @[
                      @"audit_bird.png",
                      @"event_bird.png",
                      @"support_bird.png",
                      @"aboutus_bird.png",
                      @"gps_bird.png",
                      @"impressum_bird.png"
                      ];
    
    _segues=@[@"auditionTaskSelector",@"eventTaskSelector"];
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
    // Return the number of rows in the section.
    return _labelTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = @"homeScreenCell";
    HomeScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSInteger row = indexPath.row;
    
//    if(_labelTexts.count!=_pictureNames.count){
//        @throw([NSException exceptionWithName:@"InvalidCellContentException" reason:@"The content for the cell doesn't match." userInfo:nil]);
//    }
    [cell.theImageView setImage:[UIImage imageNamed:_pictureNames[row]]];
    [cell.titleLabel setText:_labelTitles[row]];
    [cell.descriptionLabel setText:_labelDescriptions[row]];
    
    return cell;
}


/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:_segues[indexPath.row]] animated:true];
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
