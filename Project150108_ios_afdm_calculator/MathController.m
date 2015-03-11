//
//  MathController.m
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/11.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import "MathController.h"
#import "MathDatabase.h"
#import <math.h>

#define MATH_TYPE_ADD 0
#define MATH_TYPE_SUB 1
#define MATH_TYPE_MULT 2
#define MATH_TYPE_DIVI 3

#define MATH_SYMBOL_ADD @"+"
#define MATH_SYMBOL_SUB @"-"
#define MATH_SYMBOL_MULT @"*"
#define MATH_SYMBOL_DIVI @"/"

#define MATH_UNIT_2_NUM 2
#define MATH_UNIT_3_NUM 3
#define MATH_UNIT_4_NUM 4

#define LEVEL_HARD_MATH_ADD 2
#define LEVEL_HARD_MATH_SUB 2
#define LEVEL_HARD_MATH_MULT 1
#define LEVEL_HARD_MATH_DIVI 1

#define MATH_SYMBOL_ADD_TITLE @"加法"
#define MATH_SYMBOL_SUB_TITLE @"减法"
#define MATH_SYMBOL_MULT_TITLE @"乘法"
#define MATH_SYMBOL_DIVI_TITLE @"除法"

#define BUTTON_TITLE_RESULT @"结果"
#define BUTTON_TITLE_REFRESH @"新题目"
#define BUTTON_TITLE_TYPE @" %@ \n 算术 "
#define BUTTON_TITLE_UNIT @"%d个算数"


@interface MathController ()

@end

@implementation MathController {

    NSMutableArray *numbers;
    History *history;
    MathDatabase *database;

}

- (void)viewDidLoad {
    
    history = [[History alloc] init];
    
    history.mathType = MATH_TYPE_ADD;
    history.mathUnit = MATH_UNIT_2_NUM;
    
    [self refreshObject:nil];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if (database == nil) {
        database = [[MathDatabase alloc] init];
    }
    [self refreshObject:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (database != nil) {
        [database close];
        database = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showHomePage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeType:(id)sender {
    if (history.mathType == MATH_TYPE_ADD) {
        history.mathType = MATH_TYPE_SUB;
    } else if (history.mathType == MATH_TYPE_SUB) {
        history.mathType = MATH_TYPE_MULT;
    } else if (history.mathType == MATH_TYPE_MULT) {
        history.mathType = MATH_TYPE_DIVI;
    } else if (history.mathType == MATH_TYPE_DIVI) {
        history.mathType = MATH_TYPE_ADD;
    }
    [self refreshObject:nil];
}

- (IBAction)changeUnit:(id)sender {
    if (history.mathUnit == MATH_UNIT_2_NUM) {
        history.mathUnit = MATH_UNIT_3_NUM;
    } else if (history.mathUnit == MATH_UNIT_3_NUM) {
        history.mathUnit = MATH_UNIT_4_NUM;
    } else if (history.mathUnit == MATH_UNIT_4_NUM) {
        history.mathUnit = MATH_UNIT_2_NUM;
    }
    [self refreshObject:nil];
}

- (IBAction)showResult:(id)sender {
    NSString *resultStr = @"";
    
    float resultNum = [numbers count] > 0 ? [[numbers objectAtIndex:0] floatValue] : 0.0;
    if (history.mathType == MATH_TYPE_ADD) {
        for (int i=1; i<history.mathUnit; i++) {
            resultNum = resultNum + [[numbers objectAtIndex:i] floatValue];
        }
        resultStr = [NSString stringWithFormat:@"%.2f", resultNum];
    }
    else if (history.mathType == MATH_TYPE_SUB) {
        for (int i=1; i<history.mathUnit; i++) {
            resultNum = resultNum - [[numbers objectAtIndex:i] floatValue];
        }
        resultStr = [NSString stringWithFormat:@"%.2f", resultNum];
    }
    else if (history.mathType == MATH_TYPE_MULT) {
        for (int i=1; i<history.mathUnit; i++) {
            resultNum = resultNum * [[numbers objectAtIndex:i] floatValue];
        }
        resultStr = [NSString stringWithFormat:@"%.2f", resultNum];
    }
    else if (history.mathType == MATH_TYPE_DIVI) {
        int remainder = 0;
        float divider = resultNum;
        float dividend = 1;
        for (int i=1; i<history.mathUnit; i++) {
            dividend = dividend * [[numbers objectAtIndex:i] floatValue];
        }
        resultNum = divider / dividend;
        remainder = (int)divider % (int)dividend;
        resultStr = [NSString stringWithFormat:@"%.f 余 %d", floor(resultNum), remainder];
    }
    
    [self.resultButton setTitle:resultStr forState:UIControlStateNormal];
    

    if (history.isSaved == NO) {
        history.isSaved = YES;
        history.endTime = [NSDate date];
        [database saveHistory:history];
    }    
}

- (IBAction)refreshObject:(id)sender {
    
    numbers = [[NSMutableArray alloc] init];
    
    NSString *typeTitle;
    NSString *unitTitle = [NSString stringWithFormat:BUTTON_TITLE_UNIT, history.mathUnit];
    
    if (history.mathType == MATH_TYPE_ADD) {
        for (int i=0; i<history.mathUnit; i++) {
            if (i < LEVEL_HARD_MATH_ADD) {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 100)]];
            } else {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 10)]];
            }
            [numbers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj2 compare:obj1];
            }];
        }
        history.object = [self createObject:MATH_SYMBOL_ADD];
        typeTitle = [NSString stringWithFormat:BUTTON_TITLE_TYPE, MATH_SYMBOL_ADD_TITLE];
    }
    else if (history.mathType == MATH_TYPE_SUB) {
        for (int i=0; i<history.mathUnit; i++) {
            if (i < LEVEL_HARD_MATH_SUB) {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 100)]];
            } else {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 10)]];
            }
            [numbers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj2 compare:obj1];
            }];
        }
        history.object = [self createObject:MATH_SYMBOL_SUB];
        typeTitle = [NSString stringWithFormat:BUTTON_TITLE_TYPE, MATH_SYMBOL_SUB_TITLE];
    }
    else if (history.mathType == MATH_TYPE_MULT) {
        for (int i=0; i<history.mathUnit; i++) {
            if (i < LEVEL_HARD_MATH_MULT) {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 100)]];
            } else {
                [numbers addObject:[NSNumber numberWithFloat:(arc4random() % 10)]];
            }
            [numbers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj2 compare:obj1];
            }];
        }
        history.object = [self createObject:MATH_SYMBOL_MULT];
        typeTitle = [NSString stringWithFormat:BUTTON_TITLE_TYPE, MATH_SYMBOL_MULT_TITLE];
    }
    else if (history.mathType == MATH_TYPE_DIVI) {
        for (int i=0; i<history.mathUnit; i++) {
            if (i < LEVEL_HARD_MATH_DIVI) {
                float temp = (arc4random() % 100);
                while (temp == 0) {
                    temp = (arc4random() % 100);
                }
                [numbers addObject:[NSNumber numberWithFloat:temp]];
            } else {
                float temp = (arc4random() % 10);
                while (temp == 0) {
                    temp = (arc4random() % 10);
                }
                [numbers addObject:[NSNumber numberWithFloat:temp]];
            }
            [numbers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj2 compare:obj1];
            }];
        }
        
        history.object = [self createObject:MATH_SYMBOL_DIVI];
        typeTitle = [NSString stringWithFormat:BUTTON_TITLE_TYPE, MATH_SYMBOL_DIVI_TITLE];
    }
    else {
        history.object = nil;
        typeTitle = nil;
    }
    
    [self.objectButton setTitle:history.object forState:UIControlStateNormal];
    [self.typeButton setTitle:typeTitle forState:UIControlStateNormal];
    [self.otherButton setTitle:unitTitle forState:UIControlStateNormal];
    [self.resultButton setTitle:BUTTON_TITLE_RESULT forState:UIControlStateNormal];
    [self.refreshButton setTitle:BUTTON_TITLE_REFRESH forState:UIControlStateNormal];
    
    history.beginTime = [NSDate date];
    history.isSaved = NO;
    
}

- (NSString *)createObject:(NSString *)mathSymbol {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i=0; i<history.mathUnit; i++) {
        if (i < history.mathUnit - 1) {
            [str appendFormat:@"%.0f %@ ", [[numbers objectAtIndex:i] floatValue], mathSymbol];
        } else {
            [str appendFormat:@"%.0f", [[numbers objectAtIndex:i] floatValue]];
        }
    }
    return str;
}


@end
