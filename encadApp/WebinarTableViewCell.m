//
//  WebinarTableViewCell.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 20.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "WebinarTableViewCell.h"

@implementation WebinarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDateLabelText:(NSString*)date{
    _dateLabel.text=[@"Datum: " stringByAppendingString:[self convertDateString:date]];
}

-(NSString*)convertDateString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate= [formatter dateFromString:dateString];
    [formatter setDateFormat:@"EE, dd.MM.yyyy"];
    return [formatter stringFromDate:convertedDate];
}

@end
