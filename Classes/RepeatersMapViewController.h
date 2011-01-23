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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RepeatersMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
	MKMapView *mapView;
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	NSMutableArray *rpt;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocation *currentLocation;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
