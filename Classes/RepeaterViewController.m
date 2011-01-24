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

-(IBAction) viewMapClicked {
	RepeatersMapViewController *rMapView = [[RepeatersMapViewController alloc] initWithNibName:@"RepeatersMapView" bundle:nil];
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.repeaterNavController pushViewController:rMapView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden = true;
}

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


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	
	self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}


-(IBAction) segmentedControlChanged {
	NSLog(@"segmentedControlChanged called");
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
				double d = [rLoc distanceFromLocation:self.currentLocation];
				NSLog(@"%g km", d/1000);
				if((d/1000) < 20) {
					[tableData addObject:r];
				}
			}
			[uiTableView reloadData];
		break;
	}
	NSLog(@"%i", segmentedControl.selectedSegmentIndex);
}

#pragma mark -
#pragma mark Search bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarSearchButtonClicked called");
	NSPredicate *predExists = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"descr", searchBar.text];
	NSArray *t = [copiedData filteredArrayUsingPredicate:predExists];
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:t];
	[uiTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSLog(@"searchBar called");
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarCancelButtonClicked called");
	[tableData removeAllObjects];
    [tableData addObjectsFromArray:copiedData];
	[uiTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Repeater *r = (Repeater *)[tableData objectAtIndex:indexPath.row];
	MapViewController *mapView = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	mapView.selectedRepeater = r;
	
	// Pass the selected object to the new view controller.
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.repeaterNavController pushViewController:mapView animated:YES];
	[mapView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	[segmentedControl release];
	[uiTableView release];
	[currentLocation release];
    [super dealloc];
}


@end
