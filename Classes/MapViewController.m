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

#import "MapViewController.h"
#import "Repeater.h"
#import "MKAnnotation.h"

@implementation MapViewController

@synthesize mapView, selectedRepeater;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Map";
	
	/*Region and Zoom*/
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	CLLocationCoordinate2D location=mapView.userLocation.coordinate;
	NSLog(@"lat: %f, long:%f", [selectedRepeater.latitude doubleValue], [selectedRepeater.longitude doubleValue]);
	
	location.latitude=[selectedRepeater.latitude doubleValue];
	location.longitude=[selectedRepeater.longitude doubleValue];
	region.span=span;
	region.center=location;
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
	[mapView setZoomEnabled:TRUE];
	
	MKAnnotation *placemark = [[[MKAnnotation alloc] initWithCoordinate:location] autorelease];
	placemark._title = [selectedRepeater.descr substringToIndex:6];
	placemark._subtitle = [selectedRepeater.descr substringWithRange:NSMakeRange(7, [selectedRepeater.descr length]-8)];
	NSLog(@"%i %i", [selectedRepeater.descr length]-1, [selectedRepeater.descr length]);
	[mapView addAnnotation:placemark];
	[mapView selectAnnotation:placemark animated:YES];
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
	[selectedRepeater release];
    [super dealloc];
}


@end
