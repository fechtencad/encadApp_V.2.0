//
//  AuditionDatesController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 13.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionDatesController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AuditionDateTableViewCell.h"
#import "Schulungstermin.h"
#import "PDFController.h"

@interface AuditionDatesController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIToolbarDelegate>{
    AppDelegate *_delegate;
    NSFetchedResultsController *_fetchedResultController;
}

@property (nonatomic, strong) NSSortDescriptor *theDescriptor;
@property (weak, nonatomic) IBOutlet UITableView *auditionTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIToolbar *cityToolbar;
@property (nonatomic, strong) NSPredicate *thePredicate;
@property (nonatomic, strong) NSString *serverPath;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
//0=Augsburg; 1=Hamburg
@property int currentCity;

@property BOOL emptyAugsburg;
@property BOOL emptyHamburg;


@end

@implementation AuditionDatesController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Title
    self.navigationItem.title=@"Schulungen in Augsburg";
    
    //Set current city
    _currentCity=0;
    
    //Set Delegates
    [_auditionTableView setDelegate:self];
    [_auditionTableView setDataSource:self];
    
    //Configurate the data-Download
    _delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    self.theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"datum" ascending:YES];
    
    _thePredicate = [NSPredicate predicateWithFormat:@"orts_name = 'Augsburg'"];
    
    [self initCoreDataFetch];
    
    // Initialize the refresh control
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:0.349f green:0.545f blue:0.992f alpha:1.00f];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.auditionTableView addSubview:_refreshControl];
    
    //Initalize the Toolbar
    UIBarButtonItem *spaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     UIBarButtonItem *spaceRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *segItemsArray = [NSArray arrayWithObjects: @"Augsburg", @"Hamburg", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segItemsArray];
    _segmentedControl.selectedSegmentIndex=0;
    [_segmentedControl addTarget:self
                         action:@selector(changedCity:)
               forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentedControlButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_segmentedControl];
  
    NSArray *items = [NSArray arrayWithObjects:spaceLeft, segmentedControlButtonItem, spaceRight, nil];
    
    [_cityToolbar setItems:items];
    
    //Get serverPath
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _serverPath = [defaults stringForKey:@"serverPath"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)checkforEmptyTable{
       id sectionInfo = [[_fetchedResultController sections] objectAtIndex:0];
        if([sectionInfo numberOfObjects] == 0){
              if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
                    if(_theSubPredicate!=nil){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[@"Keine Termine für " stringByAppendingString:self.navigationItem.title] message:@"Für diese Schulung gibt es demnächst leider keine Schulungen in der ausgewählten Stadt. Sie können uns aber gerne eine Anfrage für eine Abhaltung über das Hotline-Tool senden." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *goBack = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:goBack];
                        UIAlertAction *openHotlineTool = [UIAlertAction actionWithTitle:@"Anfrage über das Hotline-Tool senden" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"hotline"] animated:YES];
                        }];
                        [alert addAction:openHotlineTool];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[@"Keine Termine für " stringByAppendingString:self.navigationItem.title] message:@"Für diese Schulung gibt es demnächst leider keine Schulungen in der ausgewählten Stadt. Sie können uns aber gerne eine Anfrage für eine Abhaltung senden." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
        }
}

-(void)changedCity:(UISegmentedControl*)segmentedControl{
    //Change predicate
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            _thePredicate = [NSPredicate predicateWithFormat:@"orts_name = 'Augsburg'"];
            //Change title
            self.navigationItem.title=@"Schulungen in Augsburg";
            _currentCity=0;
            break;
        case 1:
            _thePredicate = [NSPredicate predicateWithFormat:@"orts_name = 'Hamburg'"];
            //Change title
            self.navigationItem.title=@"Schulungen in Hamburg";
            _currentCity=1;
            break;
            
        default:
            break;
    }
    //reload data
    [self reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Core Data Operations

-(void)initCoreDataFetch{
    NSFetchRequest *request = self.fetchRequest;
    NSFetchedResultsController *theController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *theError = nil;
    
    theController.delegate = self;
    if([theController performFetch:&theError]){
        _fetchedResultController = theController;
    }
    else{
        NSLog(@"Couldn't fetch the Result: %@", theError );
    }
    
    //check for emtpy table
    [self checkforEmptyTable];
}

/**
 Fetch request sort by date with predicate
 */
-(NSFetchRequest *)fetchRequest{
    NSFetchRequest *theFetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *theType = [NSEntityDescription entityForName:@"Schulungstermin" inManagedObjectContext:_delegate.managedObjectContext];
    if(_theSubPredicate!=nil){
        NSPredicate *compsoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[_thePredicate,_theSubPredicate]];
        theFetch.predicate=compsoundPredicate;
    }
    else
        theFetch.predicate = _thePredicate;
    theFetch.entity = theType;
    theFetch.sortDescriptors = @[self.theDescriptor];
    return theFetch;
}

-(void)reloadData{
    [_delegate runSchulungsterminScripts];
    
    [self initCoreDataFetch];
    [_auditionTableView reloadData];
    // End the refreshing
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        NSString *title = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _fetchedResultController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id sectionInfo = [[_fetchedResultController sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"auditionDateCell";
    AuditionDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Schulungstermin *auditionDate = [_fetchedResultController objectAtIndexPath:indexPath];
    cell.titleLabel.text=auditionDate.schulungs_name;
    [cell setStartDateLabelText:auditionDate.datum];
    [cell setEndDateLabelText:auditionDate.datum withDuration:[auditionDate.dauer intValue]];
    cell.softwareLabel.text=auditionDate.zusatz;
    cell.cityLabel.text=auditionDate.orts_name;
    NSString *thePDFUrl = [[[_serverPath stringByAppendingString:@"pdf/datasheet/" ] stringByAppendingString: auditionDate.datenblatt_name] stringByAppendingString:@".pdf"];
    [cell setPDF:[thePDFUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDFController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"pdf"];
    vc.auditionDate = [_fetchedResultController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //setup
    CGRect originalRect = cell.frame;
    cell.frame=CGRectMake(-cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //animate
    [UIView transitionWithView:cell duration:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.frame=originalRect;
    } completion:nil];
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
