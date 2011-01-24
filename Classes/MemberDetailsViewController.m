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

#import "MemberDetailsViewController.h"
#import "Member.h"

@implementation MemberDetailsViewController

@synthesize selectedMember;

#pragma mark -
#pragma mark View lifecycle

// Called after the view controller has loaded.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = selectedMember.callsign;
	
	labels = [NSMutableArray new];
	values = [NSMutableArray new];
	
	[labels addObject:@"Expire Date"];
	[labels addObject:@"Apparatus Assignment"];
	[labels addObject:@"Handle"];
	
	[values addObject:selectedMember.expire];
	[values addObject:selectedMember.aa];
	[values addObject:selectedMember.handle];
}

#pragma mark -
#pragma mark Table view data source

// The number of sections in the table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [labels count];
}

// The title of the header of the specified section of the table.
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	return [labels objectAtIndex:section];
}

// The number of rows in a given section of the table.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell
    cell.textLabel.text = [values objectAtIndex:indexPath.section];
    return cell;
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
	[super dealloc];
	[selectedMember release];
	[values release];
	[labels release];
}


@end

