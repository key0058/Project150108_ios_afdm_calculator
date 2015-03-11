//
//  MathDatabase.m
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/13.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import "MathDatabase.h"
#import "FMDB.h"
#import "NSDate+Helper.h"

#define DB_NAME @"chen.db"

#define DB_CREATE_TABLE_STATEMENT @"create table if not exists history (id integer primary key autoincrement, object text, math_type integer, math_unit integer, begin_time text, end_time text, create_date text)"

#define DB_SAVE_HISTORY_STATEMENT @"insert into history (object, math_type, math_unit, begin_time, end_time, create_date) values (?, ?, ?, ?, ?, ?)"

#define DB_COUNT_AVERAGE_STATEMENT @"select total(times) / total(1) from (select strftime('%s', end_time) - strftime('%s', begin_time) times from history where math_type = ? and times < 180)"

#define DB_GET_HISTORY_STATEMENT @"select create_date, strftime('%s', end_time) - strftime('%s', begin_time) average_time, total(1) total_num from history where math_type = ? and average_time < 180 group by create_date"

#define DB_DLETE_HISTORY_STATEMENT @"delete from history"



@implementation MathDatabase {
    FMDatabase *fmdb;
}

- (MathDatabase *)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:DB_NAME];
        
        fmdb = [FMDatabase databaseWithPath:dbPath];
        
        if ([fmdb open]) {
            [fmdb executeUpdate:DB_CREATE_TABLE_STATEMENT];
            NSLog(@"++++ open DB [%@]", dbPath);
        }
    }
    return self;
}

- (void)saveHistory:(History *)history {
    if ([fmdb open] && history != nil) {
        
        NSNumber *mathType = [NSNumber numberWithInt:history.mathType];
        NSNumber *mathUnit = [NSNumber numberWithInt:history.mathUnit];
        NSString *beginTime = [history.beginTime stringWithFormat:[NSDate timeFormatString]];
        NSString *endTime = [history.endTime stringWithFormat:[NSDate timeFormatString]];
        NSString *createDate = [[NSDate date] stringWithFormat:[NSDate dateFormatString]];
        
        [fmdb beginTransaction];
        [fmdb executeUpdate:DB_SAVE_HISTORY_STATEMENT, history.object, mathType, mathUnit, beginTime, endTime, createDate];
        [fmdb commit];
        
        NSLog(@"++++ Save object[%@], date[%@]", history.object, createDate);
    }
}


- (NSMutableArray *)getHistorys:(int)mathType {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    if ([fmdb open]) {
        NSNumber *value = [NSNumber numberWithInt:mathType];
        FMResultSet *rs = [fmdb executeQuery:DB_GET_HISTORY_STATEMENT, value];
        
        while (rs.next) {
            History *history = [[History alloc] init];
            history.historyAverage = [rs intForColumn:@"average_time"];
            history.historyTotal = [rs intForColumn:@"total_num"];
            history.historyDate = [rs stringForColumn:@"create_date"];
            [results addObject:history];
        }
    }
    return results;
}

- (NSNumber *)countAverage:(int)mathType {
    int result;
    if ([fmdb open]) {
        NSNumber *value = [NSNumber numberWithInt:mathType];
        result = [fmdb intForQuery:DB_COUNT_AVERAGE_STATEMENT, value];
    }
    return [NSNumber numberWithInt:result];
}
             

- (void)clearHistory {
    if ([fmdb open]) {
        
        [fmdb beginTransaction];
        [fmdb executeUpdate:DB_DLETE_HISTORY_STATEMENT];
        [fmdb commit];
        
        NSLog(@"++++ Clear all history [%@]", [NSDate date]);
    }
}


- (void)close {
    if ([fmdb open]) {
        [fmdb close];
        NSLog(@"++++ close DB.");
    }
}

@end
