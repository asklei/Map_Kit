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

NSString *const kNewYorkTitle = @"New York City";
NSString *const kBostonTitle = @"Boston";
NSString *const kDCTitle = @"Washington D.C.";

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
    [self.map addAnnotations:[self createArrayOfCities]];
    [self.map showAnnotations:self.map.annotations animated:YES];
    [self setResponseForUserTapAndHoldOnMapView];
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

- (void)setResponseForUserTapAndHoldOnMapView {
    UILongPressGestureRecognizer *tapAndHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dropPinAtUserTouch:)];
    [self.map addGestureRecognizer:tapAndHoldRecognizer];
}

- (void)dropPinAtUserTouch:(UIGestureRecognizer *)gestureRecognizer {
    //only add a pin when the long touch begins
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //Get location of touch
        CGPoint locationTouched = [gestureRecognizer locationInView:self.map];
        //Get coordinate of touch
        CLLocationCoordinate2D touchedCoordinate = [self.map convertPoint:locationTouched toCoordinateFromView:self.map];
        //Create a pin
        MKPointAnnotation *pointTouched = [[MKPointAnnotation alloc] init];
        pointTouched.coordinate = touchedCoordinate;
        [self.map addAnnotation:pointTouched];
    }
}

- (NSArray *)createArrayOfCities {
    CLLocationCoordinate2D bostonCoordinate = CLLocationCoordinate2DMake(42.358280, -71.060966);
    CLLocationCoordinate2D newYorkCoordinate = CLLocationCoordinate2DMake(40.769626, -73.924905);
    CLLocationCoordinate2D dcCoordinate = CLLocationCoordinate2DMake(38.888930, -77.027307);
    
    MKPointAnnotation *bostonPoint = [[MKPointAnnotation alloc] init];
    bostonPoint.coordinate = bostonCoordinate;
    bostonPoint.title = kBostonTitle;
    bostonPoint.subtitle = @"Population 646,000";
    
    MKPointAnnotation *newYorkPoint = [[MKPointAnnotation alloc] init];
    newYorkPoint.coordinate = newYorkCoordinate;
    newYorkPoint.title = kNewYorkTitle;
    newYorkPoint.subtitle = @"Population 8,000,000";
    
    MKPointAnnotation *dcPoint = [[MKPointAnnotation alloc] init];
    dcPoint.coordinate = dcCoordinate;
    dcPoint.title = kDCTitle;
    dcPoint.subtitle = @"Population 1,000,000";
    
    return @[bostonPoint, newYorkPoint, dcPoint];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"After region change, latitude: %f", mapView.region.center.latitude);
    NSLog(@"After region change, longitude%f", mapView.region.center.longitude);
    NSLog(@"Span latitude delta after region change: %f", mapView.region.span.latitudeDelta);
    NSLog(@"Span longitude delta after region change: %f", mapView.region.span.longitudeDelta);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 1. If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // 2. Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // 3. If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            // 4. Customize the pin!
            pinView.pinTintColor = [UIColor purpleColor];
            pinView.canShowCallout = YES;
            //Customize the callout
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPointAnnotation *pointAnnotation = annotation;
        if ([pointAnnotation.title isEqualToString:kNewYorkTitle]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://en.wikipedia.org/wiki/New_York_City"]];
        } else if ([pointAnnotation.title isEqualToString:kBostonTitle]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://en.wikipedia.org/wiki/Boston"]];
        } else if ([pointAnnotation.title isEqualToString:kDCTitle]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://en.wikipedia.org/wiki/Washington,_D.C."]];
        }
    }
}


@end
