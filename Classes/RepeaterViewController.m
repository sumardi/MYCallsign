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

#import "RepeaterViewController.h"
#import "MYCallsignAppDelegate.h"
#import "Repeater.h"
#import "MapViewController.h"
#import "RepeatersMapViewController.h"

@implementation RepeaterViewController

@synthesize segmentedControl, uiTableView, currentLocation;

#pragma mark -
#pragma mark View lifecycle

// View the selected repeater in map.
-(IBAction) viewMapClicked {
	RepeatersMapViewController *rMapView = [[RepeatersMapViewController alloc] initWithNibName:@"RepeatersMapView" bundle:nil];
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.repeaterNavController pushViewController:rMapView animated:YES];
}

// Notifies the view controller that its view is about to be become visible.
- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden = true;
}

// Notifies the view controller that its view is about to be dismissed, covered, or otherwise hidden from view.
- (void)viewWillDisappear:(BOOL)animated {
	self.navigationController.navigationBarHidden = false;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.currentLocation = [[CLLocation alloc] init];
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager startUpdatingLocation];
	
    [super viewDidLoad];
	self.title = @"Repeater";
	
	tableData = [[NSMutableArray alloc] init];
	copiedData = [[NSMutableArray alloc] init];
	
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	tableData = appDelegate.repeaters;
	copiedData = [tableData copyWithZone:nil];
}

#pragma mark -
#pragma mark Core Location delegate

// Tells the delegate that a new location value is available.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	self.currentLocation = newLocation;
}

// Tells the delegate that the location manager was unable to retrieve a location value.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
}

#pragma mark -
#pragma mark Segmented Control

// Tells the table view to change data.
-(IBAction) segmentedControlChanged {
	switch(segmentedControl.selectedSegmentIndex) {
		case 0:
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:copiedData];
			[uiTableView reloadData];
		break;
		case 1:
			[tableData removeAllObjects];
			for(Repeater *r in copiedData) {
				CLLocation *rLoc = [[CLLocation alloc] initWithLatitude:[r.latitude doubleValue] longitude:[r.longitude doubleValue]];
				// Count the distance of specific repeater from user current location.
				double d = [rLoc distanceFromLocation:self.currentLocation]; 
				if((d/1000) < 20) {
					[tableData addObject:r];
				}
			}
			[uiTableView reloadData];
		break;
	}
}

#pragma mark -
#pragma mark Search bar delegate

// Tells the delegate that the search button was tapped.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSPredicate *predExists = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"descr", searchBar.text];
	NSArray *t = [copiedData filteredArrayUsingPredicate:predExists];
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:t];
	[uiTableView reloadData];
}

// Tells the delegate that the user changed the search text.
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if([searchText isEqualToString:@""] || searchText == nil) {
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:copiedData];
		[uiTableView reloadData];
	} else {
		NSPredicate *predExists = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"descr", searchText];
		NSArray *t = [copiedData filteredArrayUsingPredicate:predExists];
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:t];
		[uiTableView reloadData];
	}
}

// Tells the delegate that the cancel button was tapped.
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[tableData removeAllObjects];
    [tableData addObjectsFromArray:copiedData];
	[uiTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

// The number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

// The number of rows in a given section of a table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [tableData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UILabel *lblTemp1, *lblTemp2;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 8, 290, 16);
	CGRect Label2Frame = CGRectMake(10, 26, 290, 15);
		
	cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:CellIdentifier] autorelease];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	lblTemp1 = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp1.font = [UIFont boldSystemFontOfSize:16];
	[cell.contentView addSubview:lblTemp1];		
		
	lblTemp2 = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp2.font = [UIFont systemFontOfSize:11];
	lblTemp2.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp2];
		
	Repeater *r = (Repeater *)[tableData objectAtIndex:indexPath.row];
	
	lblTemp1.text = [r.descr substringWithRange:NSMakeRange(0, 6)];

	if(segmentedControl.selectedSegmentIndex == 1) {
		CLLocation *rLoc = [[CLLocation alloc] initWithLatitude:[r.latitude doubleValue] longitude:[r.longitude doubleValue]];
		double d = [rLoc distanceFromLocation:self.currentLocation];
		lblTemp2.text = [NSString stringWithFormat:@"%2.2fKM", d/1000];
	} else {
		lblTemp2.text = [r.descr substringWithRange:NSMakeRange(7, [r.descr length]-8)];
	}
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

// Tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Pass the selected repeater to the Map view controller.
	Repeater *r = (Repeater *)[tableData objectAtIndex:indexPath.row];
	MapViewController *mapView = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	mapView.selectedRepeater = r;
	
	// Push the view to the Map view controller.
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.repeaterNavController pushViewController:mapView animated:YES];
	[mapView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Sent to the view controller when the application receives a memory warning.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

// Called when the controller’s view is released from memory.
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Deallocates the memory occupied by the receiver.
- (void)dealloc {
	[segmentedControl release];
	[uiTableView release];
	[currentLocation release];
    [super dealloc];
}


@end
