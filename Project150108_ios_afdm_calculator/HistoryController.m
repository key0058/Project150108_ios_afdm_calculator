//
//  HistoryController.m
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/15.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import "HistoryController.h"
#import "MathDatabase.h"
#import "History.h"


#define MATH_TYPES @"加法,减法,乘法,除法"

#define SEG_MATH_TYPE_NUM 4

#define SEG_MATH_TYPE_ADD 0
#define SEG_MATH_TYPE_SUB 1
#define SEG_MATH_TYPE_MULT 2
#define SEG_MATH_TYPE_DIVI 3

#define SECTION_NUM 2

#define SECTION_TOTAL 0
#define SECTION_DETAIL 1

#define SECTION_TOTAL_TITLE @"历史记录"
#define SECTION_DETAIL_TITLE @"详细记录"

#define TOTAL_CELL_MSG @"%@算术的平均时间%d秒"

#define DETAIL_CELL_MSG @"%@ - 共%d题 - 平均时间:%d秒"

#define ALERT_TITLE @"注意"
#define ALERT_MESSAGE @"确认要删除所有历史记录?"
#define ALERT_BUTTON_OK @"确认"
#define ALERT_BUTTON_NO @"取消"


@interface HistoryController () <UIAlertViewDelegate>

@end

@implementation HistoryController {
    NSArray *mathTypes;
    NSString *mathTypeName;
    
    MathDatabase *database;
    
    int totalAverageTime;
    NSMutableArray *historyDetails;
}

- (void)viewDidLoad {
    
    [self initHistory];
    
    [self.mathTypeSegmented addTarget:self action:@selector(changeHistory:) forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
}

- (void)initHistory {
    if (database == nil) {
        database = [[MathDatabase alloc] init];
    }
    mathTypes = [MATH_TYPES componentsSeparatedByString:@","];
    mathTypeName = [mathTypes objectAtIndex:[self.mathTypeSegmented selectedSegmentIndex]];
    totalAverageTime = [[database countAverage:[self.mathTypeSegmented selectedSegmentIndex]] integerValue];
    historyDetails = [database getHistorys:[self.mathTypeSegmented selectedSegmentIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    if (database == nil) {
        database = [[MathDatabase alloc] init];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (database != nil) {
        [database close];
        database = nil;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_NUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SECTION_TOTAL) {
        return 1;
    } else {
        return [historyDetails count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SECTION_TOTAL) {
        return SECTION_TOTAL_TITLE;
    }
    else if (section == SECTION_DETAIL) {
        return SECTION_DETAIL_TITLE;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"historyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == SECTION_TOTAL) {
        [cell.textLabel setText:[NSString stringWithFormat:TOTAL_CELL_MSG, mathTypeName, totalAverageTime]];
    }
    else if (indexPath.section == SECTION_DETAIL) {
        History *history = [historyDetails objectAtIndex:indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:DETAIL_CELL_MSG, history.historyDate, history.historyTotal, history.historyAverage]];
    }
    
    return cell;
}


- (IBAction)closeHistory:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearHistory:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:ALERT_MESSAGE delegate:self cancelButtonTitle:ALERT_BUTTON_OK otherButtonTitles:ALERT_BUTTON_NO, nil];
    [alertView show];
}

- (void)changeHistory:(id)sender {
    [self initHistory];
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:ALERT_BUTTON_OK]) {
        [database clearHistory];
        [self initHistory];
        [self.tableView reloadData];
    }
}


@end
