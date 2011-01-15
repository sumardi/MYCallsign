//
//  CallsignViewController.h
//  MYCallsign
//
//  Created by Sumardi Shukor on 1/16/11.
//  Copyright 2011 Software Machine Development. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CallsignViewController : UIViewController {
	IBOutlet UITableViewController *tableCallsignList;
}

@property (retain, nonatomic) IBOutlet UITableViewController *tableCallsignList;

@end
