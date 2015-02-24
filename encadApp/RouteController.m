//
//  RouteController.m
//  encadApp
//
//  Created by Bernd Fecht (encad-consulting.de) on 24.02.15.
//  Copyright (c) 2015 Bernd Fecht (encad-consulting.de). All rights reserved.
//

#import "RouteController.h"
#import "RouteTableViewCell.h"

@interface RouteController ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@end

@implementation RouteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set properties
    
    //set overview label
    [self setOverviewLabelText];
    
    //set delegates
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

-(void)setOverviewLabelText{
    _overviewLabel.text=[NSString stringWithFormat:@"%0.1f Kilometer - etwa %0.0f Minuten",_route.distance/1000.0,_route.expectedTravelTime/60];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"routeCell";
    
    RouteTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
     MKRouteStep *step = _route.steps[indexPath.row];
    
    if(indexPath.row==0){
        cell.distanceLabel.text=@"Start";
        cell.directionAdviseLabel.text=step.instructions;
        step=_route.steps[indexPath.row+1]; //to prevent wrong picture
    }
    else{
        NSString *distance = [NSString stringWithFormat:@"nach %0.1fkm", step.distance / 1000.0];
        cell.distanceLabel.text=distance;
        cell.directionAdviseLabel.text=step.instructions;
    }
    cell.step=step;
    cell.stepLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    [cell.mapView addOverlay:step.polyline];
    [cell.mapView setVisibleMapRect:step.polyline.boundingMapRect animated:NO];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _route.steps.count;
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
