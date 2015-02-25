//
//  AuditionSignInController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 17.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionSignInController.h"

@interface AuditionSignInController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *auditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendRequestButton;
@property (weak, nonatomic) IBOutlet UIToolbar *accViewToolbar;

@property (nonatomic, strong) NSString *serverPath;
@property (nonatomic, strong) UITextField *activeTF;

- (IBAction)sendRequest:(id)sender;
- (IBAction)pressedCancelButton:(id)sender;
- (IBAction)pressedDoneButton:(id)sender;
- (IBAction)tapedScreen:(id)sender;

@end

@implementation AuditionSignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_audition_bird.png"]];
    imageView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setAlpha:1.0];
    
    [self.view insertSubview:imageView belowSubview:_scrollView];
    
    //set title
    self.navigationItem.title = @"Anfrage zur Schulung";
    
    //set Delegates
    _firstNameTF.delegate = self;
    _lastNameTF.delegate = self;
    _companyTF.delegate = self;
    _phoneTF.delegate = self;
    _emailTF.delegate = self;
    
    //set AccessoryViews
    _firstNameTF.inputAccessoryView=_accViewToolbar;
    _lastNameTF.inputAccessoryView=_accViewToolbar;
    _companyTF.inputAccessoryView=_accViewToolbar;
    _emailTF.inputAccessoryView=_accViewToolbar;
    _phoneTF.inputAccessoryView=_accViewToolbar;
    
    //Set scroll view
    [_scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 600.0)];
    
    //set labels
    [self setLabels];
    
    //Get server Path
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _serverPath = [defaults stringForKey:@"serverPath"];
    
    //Disable button
    _sendRequestButton.enabled=false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLabels{
    _auditionLabel.text = _auditionDate.schulungs_name;
    _dateLabel.text = [[[self convertDateString:_auditionDate.datum] stringByAppendingString:@" - "]stringByAppendingString:[self convertDateString:_auditionDate.datum WithDaysToAdd:[_auditionDate.dauer integerValue]]];
    _locationLabel.text = _auditionDate.orts_name;
}

-(NSString*)convertDateString:(NSString*)dateString WithDaysToAdd:(long)days{
    days-=1;
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc]init];
    [theFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [theFormatter dateFromString:dateString];
    NSDate *endDate = startDate;
    if(days>0){
        endDate = [startDate dateByAddingTimeInterval:60*60*24*days];
    }
    [theFormatter setDateFormat:@"EE, dd.MM.yyyy"];
    NSString *convertedDateString = [theFormatter stringFromDate:endDate];
    return convertedDateString;
}

-(NSString*)convertDateString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate= [formatter dateFromString:dateString];
    [formatter setDateFormat:@"EE, dd.MM.yyyy"];
    return [formatter stringFromDate:convertedDate];
}


- (IBAction)sendRequest:(id)sender {
    NSString *urlString = [_serverPath stringByAppendingString:[NSString stringWithFormat:@"JsonExchange/app_audition_sign_up.php?audition_name=%@&audition_location=%@&audition_start=%@&audition_end=%@&name=%@&surname=%@&email=%@&tel_number=%@&company=%@",_auditionDate.schulungs_name,_auditionDate.orts_name,[self convertDateString:_auditionDate.datum],[self convertDateString:_auditionDate.datum WithDaysToAdd:[_auditionDate.dauer integerValue]],_firstNameTF.text,_lastNameTF.text,_emailTF.text,_phoneTF.text,_companyTF.text]];
    NSURL *url = [[NSURL alloc]initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!error){
        NSLog(@"Request sent: %@",request);
        NSString *title = @"Anfrage erfolgreich gesendet";
        NSString *message = @"Ihre Anfrage wurde erfolgreich der encad consulting GmbH zugestellt. Sie erhalten demnächst eine Email mit der Bestätigung unter der angegebenen Email-Addresse. Vielen Dank!";
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        NSLog(@"Error at sending data: %@",error);
        NSString *title = @"Fehler beim Senden der Daten";
        NSString *message = @"Es ist ein Fehler beim Senden der Daten aufgetreten. Vergewissern Sie sich, dass sie mit dem Internet verbunden sind. Falls das Problem weiterhin besteht, senden Sie uns bitte eine Nachricht über das Hotline-Tool. Vielen Dank!";
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
