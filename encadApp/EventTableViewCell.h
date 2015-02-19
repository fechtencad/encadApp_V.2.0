//
//  EventTableViewCell.h
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 18.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *agendaWebView;

-(void)setStartDateLabelText:(NSString*)date;
-(void)setEndDateLabelText:(NSString*)date;
-(void)setAgendaWebViewWithURL:(NSURL*)url;

@end
