//
//  HistoryController.h
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/15.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryController : UITableViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *mathTypeSegmented;

- (IBAction)closeHistory:(id)sender;
- (IBAction)clearHistory:(id)sender;

@end
