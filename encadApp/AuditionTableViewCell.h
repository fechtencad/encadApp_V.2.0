//
//  AuditionTableViewCell.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 13.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *softwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

-(void)setDurationLableText:(NSString*)duration;

@end
