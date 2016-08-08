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
- (IBAction)performOperation:(UIButton *)sender;
- (IBAction)enter;
- (IBAction)clear;

@end

@implementation ViewController

BOOL userIsTypingNumber = NO;
double accumulator;
Operation operation;
NSMutableArray *expressionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    expressionArray = [[NSMutableArray alloc] init];
}

#pragma mark - display label

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

- (IBAction)performOperation:(UIButton *)sender {
    userIsTypingNumber = NO;
    NSString *op = sender.currentTitle;
    //[self checkLastItemIsNumeric];
    
    while (!userIsTypingNumber) {
        if ([op isEqual: @"+/-"]) {
            operation = SIGN;
            if (expressionArray.count <= 2)
                [expressionArray insertObject:@"-" atIndex:0];
            else {
                [expressionArray addObject:@"-"];
            }
            double accumulator = -[self getDisplayValue];
            [self setDisplayValue:accumulator];
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
        if ([op isEqual: @"+"]) {
            operation = ADD;
            [expressionArray addObject:op];
            break;
        }
        if ([op isEqual: @"-"]) {
            operation = SUBTRACT;
            [expressionArray addObject:op];
            break;
        }
        if ([op isEqual: @"*"]) {
            operation = MULTIPLY;
            [expressionArray addObject:op];
            break;
        }
        if ([op isEqual: @"/"]) {
            operation = DIVIDE;
            [expressionArray addObject:op];
            break;
        }
    }
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
        //NSExpression *expression = [NSExpression expressionWithFormat:numericExpression];
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
