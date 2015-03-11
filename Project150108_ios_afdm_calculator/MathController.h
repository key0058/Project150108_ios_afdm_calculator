//
//  MathController.h
//  Project150108_ios_afdm_calculator
//
//  Created by ChEN on 15/1/11.
//  Copyright (c) 2015年 ChEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *objectButton;
@property (strong, nonatomic) IBOutlet UIButton *resultButton;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (strong, nonatomic) IBOutlet UIButton *typeButton;
@property (strong, nonatomic) IBOutlet UIButton *otherButton;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

- (IBAction)refreshObject:(id)sender;
- (IBAction)showResult:(id)sender;

- (IBAction)changeType:(id)sender;
- (IBAction)changeUnit:(id)sender;

- (IBAction)showHomePage:(id)sender;

@end
