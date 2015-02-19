//
//  EventTableViewCell.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAgendaWebViewWithURL:(NSURL*)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_agendaWebView loadRequest:request];
    
}

-(void)setStartDateLabelText:(NSString*)date{
    _startDateLabel.text=[@"von: " stringByAppendingString:[self convertDateString:date]];
}

-(void)setEndDateLabelText:(NSString*)date{
    _endDateLabel.text=[@"bis: " stringByAppendingString:[self convertDateString:date]];
}

-(NSString*)convertDateString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate= [formatter dateFromString:dateString];
    [formatter setDateFormat:@"EE, dd.MM.yyyy"];
    return [formatter stringFromDate:convertedDate];
}

@end
