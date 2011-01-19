//
//  MemberDetailsViewController.h
//  MYCallsign
//
//  Created by Sumardi Shukor on 1/20/11.
//  Copyright 2011 Software Machine Development. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Member;

@interface MemberDetailsViewController : UITableViewController {
	Member *selectedMember;
	
	NSMutableArray *labels;
	NSMutableArray *values;
}

@property (nonatomic, retain) Member *selectedMember;

@end
