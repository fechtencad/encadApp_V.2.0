//
//  HotlineController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 23.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "HotlineController.h"
#import <MessageUI/MessageUI.h>

@interface HotlineController ()<UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySwitch;
@property (weak, nonatomic) IBOutlet UIToolbar *accViewToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *frontCameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *frontActionButton;
@property (weak, nonatomic) IBOutlet UIImageView *add1;
@property (weak, nonatomic) IBOutlet UIImageView *add2;
@property (weak, nonatomic) IBOutlet UIButton *deleteAdd1Button;
@property (weak, nonatomic) IBOutlet UIButton *deleteAdd2Button;
@property (weak, nonatomic) IBOutlet UILabel *additionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIPickerView *titlePicker;
@property (nonatomic, strong) NSArray *pickerItems;
@property (nonatomic, strong) NSString *messageTVPlaceholer;
@property (nonatomic, strong) NSString *file1Name;
@property (nonatomic, strong) NSString *file2Name;
@property (nonatomic, strong) NSString *emailAdress;

@property BOOL firstAddAssigned;
@property BOOL secondAddAssigned;


- (IBAction)pressedDoneButton:(id)sender;
- (IBAction)sendRequest:(id)sender;
- (IBAction)pressedUpload:(id)sender;
- (IBAction)pressedCamera:(id)sender;
- (IBAction)deleteAdd2:(id)sender;
- (IBAction)deleteAdd1:(id)sender;
- (IBAction)cancelEdit:(id)sender;


@end

@implementation HotlineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set title
    self.navigationItem.title = @"Hotline";
    
    //set background
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_support.png"]];
    imageView.frame=CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:imageView atIndex:0];
    
    //scrollView
    CGRect screensize = [[UIScreen mainScreen]bounds];
    [_scrollView setContentSize:CGSizeMake(screensize.size.width, 600.0)];
    
    //set picker items
    _pickerItems = @[@"Probleme mit der App",
                     @"Probleme bei der Anmeldung",
                     @"Lizenzprobleme"
                     ];
    
    //configure data picker
    _titlePicker = [[UIPickerView alloc]init];
    _titlePicker.backgroundColor = [UIColor whiteColor];
    
    //assign picker to tf
    [_titleTF setInputView:_titlePicker];
    
    //set delegates
    _titleTF.delegate = self;
    _messageTextView.delegate = self;
    _titlePicker.delegate = self;
    
    //set accview
    _titleTF.inputAccessoryView=_accViewToolbar;
    _messageTextView.inputAccessoryView=_accViewToolbar;
    
    //get placeholder text
    _messageTVPlaceholer = _messageTextView.text;
 
    //check for hardware
    [self checkForHardwareAndSoftware];
    
    //hide addition fields
    [self hideAdditionFields];
    
    //set UISegmentedControll
    [_prioritySwitch addTarget:self action:@selector(changedPriority:) forControlEvents:UIControlEventValueChanged];
    [_prioritySwitch setTintColor:[UIColor colorWithRed:0.486f green:0.796f blue:0.416f alpha:1.00f]];
    
    //set flags
    _firstAddAssigned = NO;
    
    //set email addresses
    _emailAdress=@"hotline@encad-consulting.de";
    
    //set textview
    _messageTextView.layer.borderWidth=0.5f;
    _messageTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    //set textcolor of title to priority
    _titleTF.textColor= [UIColor colorWithRed:0.486f green:0.796f blue:0.416f alpha:1.00f];
}

-(BOOL)insertsAreCorrect{
    if(!([_titleTF.text isEqualToString:@""] && [_messageTextView.text isEqualToString:@""] && [_messageTextView.text isEqualToString:_messageTVPlaceholer])){
        return YES;
    }
    return NO;
}

-(void)sendMail{
     Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
    [mc setMailComposeDelegate:self];
    
    NSString *emailTitle = [[_titleTF.text stringByAppendingString:@" "]stringByAppendingString:[self getPriority]];
    NSString *messageBody = _messageTextView.text;
    NSArray *toRecipents = [NSArray arrayWithObjects:_emailAdress, nil];
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    if(_firstAddAssigned){
        NSData *theData = UIImageJPEGRepresentation(_add1.image, 1.0);
        if(theData != nil){
        [mc addAttachmentData:theData mimeType:@"image/jpeg" fileName:_file1Name];
        }
    }
    else if (_secondAddAssigned){
        NSData *theData = UIImageJPEGRepresentation(_add2.image, 1.0);
        if(theData != nil){
            [mc addAttachmentData:theData mimeType:@"image/jpeg" fileName:_file2Name];
        }
    }
     //Present mail view controller on screen
    if([mailClass canSendMail])
    {
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

-(NSString*)getPriority{
    switch (_prioritySwitch.selectedSegmentIndex) {
        case 0:
            return @"!";
            break;
        case 1:
            return @"!!";
            break;
        case 2:
            return @"!!!";
            break;
            
        default:
            break;
    }
    return @"";
}

-(void)checkForHardwareAndSoftware{
    _cameraButton.enabled=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    _frontCameraButton.enabled=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    _actionButton.enabled=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    _frontActionButton.enabled=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)hideAdditionFields{
    [_additionLabel setHidden:YES];
    [_add1 setHidden:YES];
    [_add2 setHidden:YES];
    
    [_deleteAdd1Button setHidden:YES];
    [_deleteAdd2Button setHidden:YES];
}

-(void)showAdditionFieldAtIndex:(int)index{
    [_additionLabel setHidden:NO];
    switch (index) {
        case 0:
            [_add1 setHidden:NO];
            [_deleteAdd1Button setHidden:NO];
            break;
        case 1:
            [_add2 setHidden:NO];
            [_deleteAdd2Button setHidden:NO];
            break;
    
        default:
            break;
    }
}

-(void)hideAdditionFieldAtIndex:(int)index{
    if(!(_firstAddAssigned && _secondAddAssigned)){
        [_additionLabel setHidden:YES];
    }
    switch (index) {
        case 0:
            [_add1 setHidden:YES];
            [_deleteAdd1Button setHidden:YES];
            break;
        case 1:
            [_add2 setHidden:YES];
            [_deleteAdd2Button setHidden:YES];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCameraController{
    if(!_firstAddAssigned || !_secondAddAssigned){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    else{
        [self showMaximumPicturesAlert];
    }
}

-(void)showGalleryController{
    if(!_firstAddAssigned || !_secondAddAssigned){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    else{
        [self showMaximumPicturesAlert];
    }
}

-(void)showMaximumPicturesAlert{
    NSString *title = @"Maximum erreicht";
    NSString *message = @"Sie können nur bis zu zwei Bilder hochladen.";
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


#pragma mark - UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [self showCameraController];
            }
            break;
        case 2:
            [self showGalleryController];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *selectedImageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(!_firstAddAssigned){
        [_add1 setImage:selectedImage];
        _file1Name=[selectedImageURL lastPathComponent];
        _firstAddAssigned=YES;
        [self showAdditionFieldAtIndex:0];
    }
    else{
        [_add2 setImage:selectedImage];
        _file2Name=[selectedImageURL lastPathComponent];
        _secondAddAssigned=YES;
        [self showAdditionFieldAtIndex:1];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MFMailComposer Delegates

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)changedPriority:(UISegmentedControl*)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            segmentControl.tintColor= [UIColor colorWithRed:0.486f green:0.796f blue:0.416f alpha:1.00f];
            _titleTF.textColor=[UIColor colorWithRed:0.486f green:0.796f blue:0.416f alpha:1.00f];
            break;
        case 1:
            segmentControl.tintColor= [UIColor orangeColor];
            _titleTF.textColor=[UIColor orangeColor];
            break;
        case 2:
            segmentControl.tintColor= [UIColor redColor];
            _titleTF.textColor= [UIColor redColor];
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //we don't need that
    _actionButton.enabled=NO;
    _cameraButton.enabled=NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //restore
    _actionButton.enabled=YES;
    _cameraButton.enabled=YES;
}

#pragma mark - UITextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //push up
    [self.view setFrame:CGRectMake(0.0, -1*_messageTextView.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //push down
    [self.view setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
}


#pragma mark - UIView Delegates

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UIPickerView Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerItems.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickerItems[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _titleTF.text=_pickerItems[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Events

- (IBAction)pressedDoneButton:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)sendRequest:(id)sender {
    if([self insertsAreCorrect]){
        [self sendMail];
    }
}

- (IBAction)pressedUpload:(id)sender {
    NSString *title = @"";
    NSString *message = @"";
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Foto od. Video aufnehmen" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showCameraController];
            }];
            [alert addAction:camera];
        }
        UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Fotoalben" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showGalleryController];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Abbrechen" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:gallery];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
        NSArray *buttonTitles;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            buttonTitles=@[@"Foto od. Video aufnehmen",@"Fotoalben"];
        }
        else{
            buttonTitles=@[@"",@"Fotoalben"];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Foto od. Video aufnehmen",@"Fotoalben", nil];
        [alert show];
    }
}

- (IBAction)pressedCamera:(id)sender {
    [self showCameraController];
}

- (IBAction)deleteAdd2:(id)sender {
    _secondAddAssigned=NO;
    [self hideAdditionFieldAtIndex:1];
    _add2.image=nil;
    _file2Name=nil;
}

- (IBAction)deleteAdd1:(id)sender {
    _firstAddAssigned=NO;
    [self hideAdditionFieldAtIndex:0];
    _add1.image=nil;
    _file1Name=nil;
}

- (IBAction)cancelEdit:(id)sender {
    [self.view endEditing:YES];
}
@end
