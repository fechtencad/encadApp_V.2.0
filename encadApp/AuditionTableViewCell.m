//
//  AuditionTableViewCell.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 13.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "AuditionTableViewCell.h"

@implementation AuditionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDurationLableText:(NSString*)duration{
    self.durationLabel.text=[duration stringByAppendingString:@" Tage"];
}

@end
