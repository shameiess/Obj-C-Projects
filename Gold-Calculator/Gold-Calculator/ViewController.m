//
//  ViewController.m
//  Gold-Calculator
//
//  Created by Kevin Nguyen on 8/3/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"

typedef enum {ADD, SUBTRACT, MULTIPLY, DIVIDE, PERCENT, SIGN} Operation;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *display;
- (IBAction)appendDigit:(UIButton *)sender;
- (IBAction)binaryOperation:(UIButton *)sender;
- (IBAction)enter;
- (IBAction)clear;

@end

@implementation ViewController

BOOL userIsTypingNumber = NO;
BOOL operationFlag = NO;
double accumulator;
Operation operation;
NSMutableArray *expressionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    expressionArray = [[NSMutableArray alloc] init];
}

#pragma mark - Display labels getters and setters

- (double)getDisplayValue {
    return [self.display.text doubleValue];
}
- (void)setDisplayValue:(double)value {
    self.display.text = [NSString stringWithFormat: @"%g", value];
}


#pragma mark - Button Actions
- (IBAction)appendDigit:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    [expressionArray addObject:digit];
    NSLog(@"Array: %@", expressionArray);
    
    if (userIsTypingNumber) {
        self.display.text = [NSString stringWithFormat: @"%@%@", _display.text, digit];
    }
    else {
        self.display.text = digit;
        userIsTypingNumber = YES;
    }
}

- (IBAction)unaryOperation:(UIButton *)sender {
    //    userIsTypingNumber = NO;
    //    operationFlag = NO;
    NSString *op = sender.currentTitle;
    
    while (true) {
        if ([op isEqual: @"+/-"]) {
            operation = SIGN;
            
            if ([_display.text hasPrefix:@"-"]) {
                self.display.text = [_display.text substringFromIndex:1];
            }
            else {
                self.display.text = [@"-" stringByAppendingString:_display.text];
            }
            
            NSArray *sign = [[NSArray alloc]initWithObjects:@"*",@"-",@"1", nil];
            
            if (expressionArray.count == 0 || (userIsTypingNumber == NO && operationFlag == YES)) {
                [expressionArray addObject:@"-"];
            }
            else {
                [expressionArray addObjectsFromArray:sign];
            }
            NSLog(@"Array: %@", expressionArray);
            break;
        }
        
        if ([op isEqual: @"%"]) {
            operation = PERCENT;
            NSArray* percent = [[NSArray alloc]initWithObjects:@"/",@"100", nil];
            [expressionArray addObjectsFromArray:percent];
            double accumulator = [self getDisplayValue]/100;
            [self setDisplayValue:accumulator];
            break;
        }
    }
}

- (IBAction)binaryOperation:(UIButton *)sender {
    userIsTypingNumber = NO;
    operationFlag = YES;
    NSString *op = sender.currentTitle;
    [self checkLastItemIsNumeric];
    [expressionArray addObject:op];
    
    NSLog(@"Array: %@", expressionArray);
}

- (IBAction)enter {
    NSLog(@"Array: %@", expressionArray);
    [self calculateExpression];
}

- (IBAction)clear {
    accumulator = 0;
    self.display.text = @"0";
    [expressionArray removeAllObjects];
    NSLog(@"Array: %@", expressionArray);
}

#pragma mark - Calculations
- (NSNumber *)calculateExpression {
    [self checkLastItemIsNumeric];
    NSNumber *result;
    double total;
    
    @try {
        NSString *numericExpression = [expressionArray componentsJoinedByString:@""];
        NSPredicate *parsed = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"1.0 * %@ = 0", numericExpression]];
        NSExpression *expression = [(NSComparisonPredicate *)parsed leftExpression];
        result = [expression expressionValueWithObject:nil context:nil];
        NSLog(@"Expression: %@", expression);
        NSLog(@"Result: %@", result);
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);}
    
    total = [result doubleValue];
    [self setDisplayValue:total];
    return result;
}

- (void) checkLastItemIsNumeric {
    NSString *lastItem = [expressionArray lastObject];
    BOOL lastItemIsNumeric = [lastItem rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
    if (!lastItemIsNumeric) {
        [expressionArray removeLastObject];
    }
}

@end