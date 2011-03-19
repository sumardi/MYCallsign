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

#import "MYCallsignAppDelegate.h"
#import "Member.h"
#import "SearchNavController.h"
#import "RepeaterNavController.h"
#import "Repeater.h"
#import "iRate.h"

@implementation MYCallsignAppDelegate

@synthesize window;
@synthesize tabBarController, searchNavController, repeaterNavController;
@synthesize members,repeaters;

// Configure iRate
+ (void)initialize {
	[iRate sharedInstance].appStoreID = 398566279;
}

#pragma mark -
#pragma mark Application lifecycle

// Create a new connection to the database.
- (void) newDatabaseConnection {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:dbPath];
	
	if(success) return;
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
	
	[fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
	[fileManager release];
}

// Read and store members from the database.
- (void) readMembers {
	sqlite3 *database;
	
	members = [[NSMutableArray alloc] init];

	static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
	
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		for(int i = 0; i < [letters length]; i++) {
			NSString *sqlStr = [NSString stringWithFormat:@"select * from members where handle like '%c%%' order by handle", toupper([letters characterAtIndex:i])];
			const char *sqlStatement = [sqlStr UTF8String];
			sqlite3_stmt *compiledStatement;
			
			NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
			NSMutableArray *handles = [[[NSMutableArray alloc] init] autorelease];
			
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					NSString *dCallsign = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					NSString *dHandle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *dExpire = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					NSString *dAa = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				
					// Create a new member object with the data from the database
					Member *m = [[Member alloc] iniWithCallsign:dCallsign handle:dHandle expire:dExpire aa:dAa];
					
					// Add the member object to the handles Array
					[handles addObject:m];
					
					[m release];
				}
				char currentLetter[2] = { toupper([letters characterAtIndex:i]), '\0'};
				[row setValue:[NSString stringWithCString:currentLetter encoding:NSASCIIStringEncoding] forKey:@"headerTitle"];
				[row setValue:handles forKey:@"rowValues"];
				[members addObject:row];
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
		}
	}
	sqlite3_close(database);
}

// Read and store repeaters from the database.
- (void) readRepeaters {
	sqlite3 *database;
	
	repeaters = [[NSMutableArray alloc] init];
	
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
			NSString *sqlStr = [NSString stringWithFormat:@"select * from repeaters"];
			const char *sqlStatement = [sqlStr UTF8String];
			sqlite3_stmt *compiledStatement;
		
			if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					NSString *dLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					NSString *dLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSMutableString *dDescription = [NSMutableString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					[dDescription replaceOccurrencesOfString:@" \"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [dDescription length])];
					
					Repeater *r = [[Repeater alloc] initWithLongitude:dLongitude latitude:dLatitude description:dDescription];
					// Add the repeater object to the handles Array
					[repeaters addObject:r];
					[r release];
				}
			}
			// Release the compiled statement from memory
			sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

// Override point for customization after application launch.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    dbName = @"mycallsign_db.sqlite3";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	dbPath = [documentsDir stringByAppendingPathComponent:dbName];
	
	// Execute the "checkAndCreateDatabase" function
	[self newDatabaseConnection];
	
	[self readMembers];
	[self readRepeaters];
	
    [self.window makeKeyAndVisible];
	[self.window addSubview:tabBarController.view];
    return YES;
}


#pragma mark -
#pragma mark Memory management

// Deallocates the memory occupied by the receiver.
- (void)dealloc {
    [window release];
	[tabBarController release];
	[members release];
	[repeaters release];
	[searchNavController release];
	[repeaterNavController release];
	
    [super dealloc];
}


@end
