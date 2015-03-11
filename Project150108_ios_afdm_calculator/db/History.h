//
//  History.h
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/13.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property BOOL isSaved;
@property int mathType;
@property int mathUnit;

@property (strong, nonatomic) NSString *object;
@property (strong, nonatomic) NSDate *beginTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSDate *createDate;


@property int historyTotal;
@property int historyAverage;
@property (strong, nonatomic) NSString *historyDate;


@end
