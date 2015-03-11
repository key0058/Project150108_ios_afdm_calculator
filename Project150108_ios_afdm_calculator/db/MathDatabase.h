//
//  MathDatabase.h
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/13.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "History.h"

@interface MathDatabase : NSObject

- (void)saveHistory:(History *)history;
- (void)clearHistory;

- (NSMutableArray *)getHistorys:(int)mathType;
- (NSNumber *)countAverage:(int)mathType;

- (void)close;

@end
