//
//  ViewController.m
//  Map-Kit-Test
//
//  Created by Lei Xu on 7/28/16.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "ViewController.h"  
#import "Masonry.h"

@interface ViewController ()
@property(nonatomic) MKMapView *map;
@property(nonatomic) UISegmentedControl *segmentedControl;
@property(nonatomic) NSArray *segmentItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect fullScreenBounds = [[UIScreen mainScreen] bounds];
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, fullScreenBounds.size.width, fullScreenBounds.size.height)];
    [self loadSegments];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segmentItems];
    [self.view addSubview:self.map];
    [self.view addSubview:self.segmentedControl];
    
    [self.segmentedControl addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSegments {
    self.segmentItems = @[@"Standard", @"Hybrid", @"Satellite"];
}

- (void)selectSegment:(UIControlEvents)controlEvents{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.map.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.map.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.map.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}


@end
