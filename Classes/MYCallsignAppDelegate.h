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
#import <sqlite3.h>
@class SearchNavController;
@class RepeaterNavController;

@interface MYCallsignAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	IBOutlet SearchNavController *searchNavController;
	IBOutlet RepeaterNavController *repeaterNavController;
	
	// Database variables
	NSString *dbName;
	NSString *dbPath;
	
	// An array to store the member objects
	NSMutableArray *members;
	
	// An array to store the repeater objects
	NSMutableArray *repeaters;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSMutableArray *repeaters;
@property (nonatomic, retain) IBOutlet SearchNavController *searchNavController;
@property (nonatomic, retain) IBOutlet RepeaterNavController *repeaterNavController;

@end

