//
//  AuditionDateTableViewCell.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 12.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditionDateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *softwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

-(void)setPDF:(NSString *)inUrl;
-(void)setStartDateLabelText:(NSString*)date;
-(void)setEndDateLabelText:(NSString*)date withDuration:(int)duration;

@end
