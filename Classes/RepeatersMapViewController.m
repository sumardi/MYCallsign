// MYCallsign - The Malaysian Amateur Radio iPhone app.
// 
// Copyright (C) 2010  Software Machine Development <support@smd.com.my> - 
// Sumardi Shukor <me@sumardi.net>
// 
// MYCallsign is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with MYCallsign. If not, see <http://www.gnu.org/licenses/>

#import "RepeatersMapViewController.h"
#import "Repeater.h"
#import "MKAnnotation.h"
#import "MYCallsignAppDelegate.h"

#define BASE_RADIUS 0.0144927536 // equal to 1 mile

@implementation RepeatersMapViewController

@synthesize mapView, currentLocation;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
		locationManager.distanceFilter = kCLDistanceFilterNone;
		[locationManager startUpdatingLocation];
    }
	NSLog(@"%@", self.currentLocation.coordinate);
    return self;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	
	region.span = span; // Set the region's span to the new span.
	region.center = newLocation.coordinate;
	[mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}


- (MKAnnotationView *) mapView: (MKMapView *) mapView_ viewForAnnotation: (id ) annotation_ {
	MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"YourPinId"];
	if ([annotation_ isKindOfClass:[MKUserLocation class]])
		return nil; 
	
	if (pin == nil) {
		pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation_ reuseIdentifier: @"YourPinId"] autorelease];
	} else {
		pin.annotation = annotation_;
	}
	pin.pinColor = MKPinAnnotationColorRed;
	[pin setCanShowCallout:YES]; // IMPORTANT
	pin.animatesDrop = YES;
	return pin;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Map View";
	
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	rpt = appDelegate.repeaters;
	
	mapView.zoomEnabled = YES;
	mapView.scrollEnabled = YES;
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	mapView.showsUserLocation = YES;
	
	span.latitudeDelta = BASE_RADIUS * 18;  
	span.longitudeDelta = BASE_RADIUS * 18;
	region.span = span;
	
	CLLocationCoordinate2D location = mapView.userLocation.coordinate;
		
	for(Repeater *r in rpt) {
		location.latitude=[r.latitude doubleValue];
		location.longitude=[r.longitude doubleValue];
		region.center = location;
		
		MKAnnotation *placemark = [[[MKAnnotation alloc] initWithCoordinate:location] autorelease];
		placemark._title = [r.descr substringToIndex:6];
		placemark._subtitle = [r.descr substringWithRange:NSMakeRange(7, [r.descr length]-8)];
		[mapView addAnnotation:placemark];
	}	
	[mapView setRegion:region animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
	[currentLocation release];
    [super dealloc];
}


@end
