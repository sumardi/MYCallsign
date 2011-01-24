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

#import "CallsignViewController.h"
#import "Member.h"
#import "MYCallsignAppDelegate.h"
#import "MemberDetailsViewController.h"

@implementation CallsignViewController

@synthesize tableCallsignList, uiTableView, uiSearchBar, membersArray;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Search";
	
	tableData = [[NSMutableArray alloc] init];
	copiedData = [[NSMutableArray alloc] init];
	
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	tableData = appDelegate.members;
	copiedData = [tableData copyWithZone:nil];
	
	NSMutableSet *set = [NSMutableSet setWithArray:[tableData valueForKey:@"rowValues"]];
	NSArray *q = [set allObjects];
	
	// Use set to merge the arrays
	NSMutableSet *s = [[NSMutableSet alloc] init];
	for(NSArray *t in q) {
		[s addObjectsFromArray:t];
	}
	self.membersArray = [s allObjects];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	NSLog(@"searchBarTextDidBeginEditing method");
	// Do nothing
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSLog(@"searchBar method");
	if([searchText isEqualToString:@""] || searchText == nil) {
		[tableData removeAllObjects];
		//tableData = [copiedData copyWithZone:nil];
		[tableData addObjectsFromArray:copiedData];
		//tableData = [copiedData copy];
		[uiTableView reloadData];
		//return;
	} else {
		[tableData removeAllObjects];
	
		NSMutableArray *resultArray = [[NSMutableArray alloc] init];
		NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
		[row setValue:[NSString stringWithString:@""] forKey:@"headerTitle"];
	
		NSPredicate *predExists = [NSPredicate predicateWithFormat:
								@"(%K contains[cd] %@) || (%K contains[cd] %@)", @"handle", searchText, @"callsign", searchText];
		NSArray *filteredArray = [self.membersArray filteredArrayUsingPredicate:predExists];

		[row setValue:filteredArray forKey:@"rowValues"];
		[resultArray addObject:row];
		[tableData addObjectsFromArray:resultArray];
		[uiTableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarCancelButtonClicked method");
	[tableData removeLastObject];
	[tableData addObjectsFromArray:copiedData];
	[searchBar resignFirstResponder];
	[uiTableView reloadData];
	return;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarSearchButtonClicked method");
	NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
	[row setValue:[NSString stringWithString:@""] forKey:@"headerTitle"];
	
	NSPredicate *predExists = [NSPredicate predicateWithFormat:
							   @"(%K contains[cd] %@) || (%K contains[cd] %@)", @"handle", searchBar.text, @"callsign", searchBar.text];
	NSArray *filteredArray = [self.membersArray filteredArrayUsingPredicate:predExists];
	
	[row setValue:filteredArray forKey:@"rowValues"];
	[tableData addObject:row];
	[uiTableView reloadData];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarResultsListButtonClicked method");
	NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
	[row setValue:[NSString stringWithString:@""] forKey:@"headerTitle"];
	
	NSPredicate *predExists = [NSPredicate predicateWithFormat:
							   @"(%K contains[cd] %@) || (%K contains[cd] %@)", @"handle", searchBar.text, @"callsign", searchBar.text];
	NSArray *filteredArray = [self.membersArray filteredArrayUsingPredicate:predExists];
	
	[row setValue:filteredArray forKey:@"rowValues"];
	[tableData addObject:row];
	[uiTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return tableData.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[[tableData objectAtIndex:section] objectForKey:@"rowValues"] count] ;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	// Return the section titles to display.
	return [tableData valueForKey:@"headerTitle"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	// Return an index value of the section you're currently touching in the index.
	return [[[tableData valueForKey:@"headerTitle"] retain] indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Return titles to each section header.
	return [[tableData objectAtIndex:section] objectForKey:@"headerTitle"];
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	Member *m = (Member *)[[[tableData objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
	cell.textLabel.text = [m.handle capitalizedString];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Member *m = (Member *)[[[tableData objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
	MemberDetailsViewController *mDetailsView = [[MemberDetailsViewController alloc] initWithNibName:@"MemberDetailsView" bundle:nil];
	mDetailsView.selectedMember = m;
	[m release];
	
	// Pass the selected object to the new view controller.
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.searchNavController pushViewController:mDetailsView animated:YES];
	[mDetailsView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableCallsignList release];
	[uiTableView release];
	[uiSearchBar release];
	[membersArray release];
    [super dealloc];
}


@end

