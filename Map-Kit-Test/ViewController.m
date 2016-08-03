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
    
    self.map.delegate = self;
    [self.segmentedControl addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(37.7746, -122.4186);
    MKCoordinateSpan newSpan = MKCoordinateSpanMake(0.014, 0.01);
    self.map.region = [self.map regionThatFits:MKCoordinateRegionMake(newCoordinate, newSpan)];
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

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"After region change, latitude: %f", mapView.region.center.latitude);
    NSLog(@"After region change, longitude%f", mapView.region.center.longitude);
    NSLog(@"Span latitude delta after region change: %f", mapView.region.span.latitudeDelta);
    NSLog(@"Span longitude delta after region change: %f", mapView.region.span.longitudeDelta);
}


@end
