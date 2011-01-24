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
#pragma mark View lifecycle

// Called after the view controller has loaded.
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
}

#pragma mark -
#pragma mark Search bar

// Tells the delegate that the user changed the search text.
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if([searchText isEqualToString:@""] || searchText == nil) {
		[tableData removeAllObjects];
		[tableData addObjectsFromArray:copiedData];
		[uiTableView reloadData];
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

// Tells the delegate that the cancel button was tapped.
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[tableData removeLastObject];
	[tableData addObjectsFromArray:copiedData];
	[searchBar resignFirstResponder];
	[uiTableView reloadData];
	return;
}

// Tells the delegate that the search button was tapped.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
	[row setValue:[NSString stringWithString:@""] forKey:@"headerTitle"];
	
	NSPredicate *predExists = [NSPredicate predicateWithFormat:
							   @"(%K contains[cd] %@) || (%K contains[cd] %@)", @"handle", searchBar.text, @"callsign", searchBar.text];
	NSArray *filteredArray = [self.membersArray filteredArrayUsingPredicate:predExists];
	
	[row setValue:filteredArray forKey:@"rowValues"];
	[tableData addObject:row];
	[uiTableView reloadData];
}

// Tells the delegate that the search results list button was tapped.
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
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

// The number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return tableData.count;
}

// The number of rows in a given specific section of the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[[tableData objectAtIndex:section] objectForKey:@"rowValues"] count] ;
}

// The titles for the sections for a table view.
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	// Return the section titles to display.
	return [tableData valueForKey:@"headerTitle"];
}

// The index of the section having the given title and section title index.
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	// Return an index value of the section you're currently touching in the index.
	return [[[tableData valueForKey:@"headerTitle"] retain] indexOfObject:title];
}

// The title of the header of the specified section of the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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


#pragma mark -
#pragma mark Table view delegate

// Tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Pass the selected member object to the MemberDetails view controller.
	Member *m = (Member *)[[[tableData objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
	MemberDetailsViewController *mDetailsView = [[MemberDetailsViewController alloc] initWithNibName:@"MemberDetailsView" bundle:nil];
	mDetailsView.selectedMember = m;
	[m release];
	
	// Create and push MemberDetails view controller.
	MYCallsignAppDelegate *appDelegate = (MYCallsignAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.searchNavController pushViewController:mDetailsView animated:YES];
	[mDetailsView release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

// Sent to the view controller when the application receives a memory warning.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

// Deallocates the memory occupied by the receiver.
- (void)dealloc {
	[tableCallsignList release];
	[uiTableView release];
	[uiSearchBar release];
	[membersArray release];
    [super dealloc];
}


@end

