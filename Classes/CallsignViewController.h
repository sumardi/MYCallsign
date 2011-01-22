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

@interface CallsignViewController : UITableViewController <UISearchBarDelegate> {
	// A table list
	IBOutlet UITableViewController *tableCallsignList;
	UITableView *uiTableView;
	NSMutableArray *tableData;
	NSMutableArray *filteredData;
	UISearchBar *uiSearchBar;
	
	NSArray *membersArray;
}

@property (nonatomic, retain) IBOutlet UITableViewController *tableCallsignList;
@property (nonatomic, retain) IBOutlet UITableView *uiTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *uiSearchBar;
@property (nonatomic, retain) NSArray *membersArray;

@end
