//
//  EventSignInController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "EventSignInController.h"

@interface EventSignInController ()<UITextFieldDelegate>

//Toolbar
@property (strong, nonatomic) IBOutlet UIToolbar *accViewToolbar;
//ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//Lable
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//Button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendRequestButton;
//TextField
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
//Other
@property (strong, nonatomic) NSString *serverPath;
@property (strong, nonatomic) UITextField *activeTF;

//Action
- (IBAction)sendRequest:(id)sender;
- (IBAction)pressedCancelButton:(id)sender;
- (IBAction)pressedDoneButton:(id)sender;
- (IBAction)tapedScreen:(id)sender;

@end

@implementation EventSignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_event_bird.png"]];
    imageView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setAlpha:1.0];
    
    [self.view insertSubview:imageView belowSubview:_scrollView];
    
    //set title
    if(_event)
        self.navigationItem.title = @"Anfrage zu einer Veranstaltung";
    
    if(_webinar)
        self.navigationItem.title = @"Anfrage zu einem Webinar";
    
    //set AccessoryViews
    _firstNameTF.inputAccessoryView=_accViewToolbar;
    _lastNameTF.inputAccessoryView=_accViewToolbar;
    _companyTF.inputAccessoryView=_accViewToolbar;
    _emailTF.inputAccessoryView=_accViewToolbar;
    _phoneTF.inputAccessoryView=_accViewToolbar;
    
    //set Delegates
    _firstNameTF.delegate = self;
    _lastNameTF.delegate = self;
    _companyTF.delegate = self;
    _phoneTF.delegate = self;
    _emailTF.delegate = self;
    
    //Set scroll view
    [_scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 600.0)];
    
    //Get server Path
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _serverPath = [defaults stringForKey:@"serverPath"];
    
    //Disable button
    _sendRequestButton.enabled=false;
    
    //Set up view
    [self checkForEventTypeAndInitialiseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkForEventTypeAndInitialiseView{
    if(_event)
       [self initEventData];
    if(_webinar)
        [self initWebinarData];
}

-(void)initEventData{
    self.typeLabel.text=@"Ich interressiere mich für folgende Veranstaltung";
    self.titleLabel.text=_event.name;
    self.dateLabel.text=[NSString stringWithFormat:@"von: %@ bis: %@",[self convertDateString:_event.anfangs_datum],[self convertDateString:_event.end_datum]];
    self.timeLabel.text=[@"Uhrzeit:" stringByAppendingString:_event.uhrzeit];
    self.locationLabel.text=[@"Ort: " stringByAppendingString:_event.ort];
}

//TODO: implement after db set
-(void)initWebinarData{
    
}

-(NSString*)convertDateString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate= [formatter dateFromString:dateString];
    [formatter setDateFormat:@"EE, dd.MM.yyyy"];
    return [formatter stringFromDate:convertedDate];
}

- (IBAction)sendRequest:(id)sender {
    NSString *urlString = [_serverPath stringByAppendingString:[NSString stringWithFormat:@"JsonExchange/app_event_sign_up.php?event_name=%@&event_location=%@&event_start=%@&event_end=%@&name=%@&surname=%@&email=%@&tel_number=%@&company=%@",_event.name,_event.ort,[self convertDateString:_event.anfangs_datum],[self convertDateString:_event.end_datum],_firstNameTF.text,_lastNameTF.text,_emailTF.text,_phoneTF.text,_companyTF.text]];
    NSURL *url = [[NSURL alloc]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error){
        NSLog(@"Request sent: %@",request);
    }
    else{
        NSLog(@"Error at sending data: %@",error);
    }
}

- (IBAction)pressedCancelButton:(id)sender {
    _activeTF.text=@"";
    [self.view endEditing:YES];
}

- (IBAction)pressedDoneButton:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapedScreen:(id)sender {
    [self.view endEditing:YES];
}

//Push view
-(void)pushViewDown{
    [self.view setFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
}
//Push view
-(void)pushViewUp:(float)size{
    [self.view setFrame:CGRectMake(0.0, -size, self.view.bounds.size.width, self.view.bounds.size.height)];
    
}

#pragma mark - UITextField Delegates

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==_companyTF || textField==_phoneTF || textField==_emailTF){
        [self pushViewDown];
    }
    else if(!([_firstNameTF.text isEqualToString:@""] && [_lastNameTF.text isEqualToString:@""] && [_emailTF.text isEqualToString:@""])){
        _sendRequestButton.enabled=true;
    }
    else
        _sendRequestButton.enabled=false;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _activeTF = textField;
    if(textField==_phoneTF || textField==_emailTF){
        [self pushViewUp:200.0f];
    }
    else if(textField==_companyTF){
        [self pushViewUp:50.0f];
    }
}

@end
