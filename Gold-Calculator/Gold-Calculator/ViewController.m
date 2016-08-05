//
//  ViewController.m
//  Gold-Calculator
//
//  Created by Kevin Nguyen on 8/3/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"

typedef enum {ADD, SUBTRACT, MULTIPLY, DIVIDE, PERCENT, SIGN, CLEAR, DECIMAL, EQUAL} Operation;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *display;
- (IBAction)appendDigit:(UIButton *)sender;
- (IBAction)performOperation:(UIButton *)sender;
- (IBAction)enter;

@end

@implementation ViewController

BOOL userIsTypingNumber = NO;
double accumulator;
double secondNumber;
double total;
Operation operation;

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)setDisplayValue:(double)value {
    self.display.text = [NSString stringWithFormat: @"%g", value];
}

- (double)getDisplayValue {
    return [self.display.text doubleValue];
}
- (void)clearCalculator {
    accumulator = 0;
    secondNumber = 0;
    total = 0;
    [self setDisplayValue:0];
}

- (IBAction)appendDigit:(UIButton *)sender {
    NSString *digit = sender.currentTitle;

    if (userIsTypingNumber) {
        self.display.text = [NSString stringWithFormat: @"%@%@", _display.text, digit];
    }
    else {
        self.display.text = digit;
        userIsTypingNumber = YES;
    }
    NSLog(@"%@", _display.text);
}

//NSMutableArray *stack = nil;


- (IBAction)performOperation:(UIButton *)sender {
    userIsTypingNumber = NO;
    NSString *op = sender.currentTitle;

    while (!userIsTypingNumber) {
        if ([op isEqual: @"AC"]) {
            operation = CLEAR;
            [self clearCalculator];
            break;
        }
        if ([op isEqual: @"C"]) {
            operation = CLEAR;
            [self clearCalculator];
            break;
        }
        if ([op isEqual: @"%"]) {
            operation = PERCENT;
            accumulator = [self getDisplayValue];
            accumulator = accumulator / 100;
            [self setDisplayValue:accumulator];
            break;
        }
        if ([op isEqual: @"+/-"]) {
            operation = SIGN;
            accumulator = -[self getDisplayValue];
            [self setDisplayValue:accumulator];
            break;
        }
        if ([op isEqual: @"+"]) {
            operation = ADD;
            accumulator = [self getDisplayValue];
            break;
        }
        if ([op isEqual: @"-"]) {
            operation = SUBTRACT;
            accumulator = [self getDisplayValue];
            break;
        }
        if ([op isEqual: @"*"]) {
            operation = MULTIPLY;
            accumulator = [self getDisplayValue];
            break;
        }
        if ([op isEqual: @"/"]) {
            operation = DIVIDE;
            accumulator = [self getDisplayValue];
            break;
        }
        accumulator = [self getDisplayValue];

    }

    NSLog(@"Op: %@", op);
    NSLog(@"Acc: %f", accumulator);
    NSLog(@"Sec: %f", secondNumber);
}

- (IBAction)enter {
    switch (operation) {
        case CLEAR:
            break;
        case PERCENT:
            total = [self getDisplayValue];
            break;
        case SIGN:
            break;
        case ADD:
            secondNumber = [_display.text doubleValue];
            total = accumulator + secondNumber;
            break;
        case SUBTRACT:
            secondNumber = [_display.text doubleValue];
            total = accumulator - secondNumber;
            break;
        case MULTIPLY:
            secondNumber = [_display.text doubleValue];
            total = accumulator * secondNumber;
            break;
        case DIVIDE:
            secondNumber = [_display.text doubleValue];
            total = accumulator / secondNumber;
            break;
        default: break;
    }
    [self setDisplayValue:total];
    NSLog(@"Tot: %f", total);
}



@end
