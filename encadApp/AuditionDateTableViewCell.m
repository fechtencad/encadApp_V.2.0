//
//  AuditionDateTableViewCell.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 12.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionDateTableViewCell.h"

@implementation AuditionDateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPDF:(NSString *)inUrl{
    NSURL *theURL = [NSURL URLWithString:inUrl];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    
    [_pdfWebView loadRequest:theRequest];
    
}

-(void)setStartDateLabelText:(NSString*)date{
    self.startDateLabel.text = [NSString stringWithFormat:@"von: %@",[self convertDateString:date]];
}

-(void)setEndDateLabelText:(NSString*)date withDuration:(int)duration{
    self.endDateLabel.text = [NSString stringWithFormat:@"bis:  %@",[self convertDateString:date WithDaysToAdd:duration]];
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



@end
