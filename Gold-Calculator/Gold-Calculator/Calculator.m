//
//  Calculator.m
//  Gold-Calculator
//
//  Created by Kevin Nguyen on 8/23/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "Calculator.h"

@interface Calculator()

@property double resultTotal;

@end

@implementation Calculator

- (NSNumber *)calculateExpressionWithCalculationArray:(NSMutableArray *)array {
    [self checkLastItemIsNumericWithArray:array];
    NSNumber *result;
    
    @try {
        NSString *numericExpression = [array componentsJoinedByString:@""];
        NSPredicate *parsed = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"1.0 * %@ = 0", numericExpression]];
        NSExpression *expression = [(NSComparisonPredicate *)parsed leftExpression];
        result = [expression expressionValueWithObject:nil context:nil];
        NSLog(@"Expression: %@", expression);
        NSLog(@"Result: %@", result);
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);}
    
    self.resultTotal = [result doubleValue];

    return result;
}

- (void) checkLastItemIsNumericWithArray:(NSMutableArray *)array {
    NSString *lastItem = [array lastObject];
    BOOL lastItemIsNumeric = [lastItem rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
    if (!lastItemIsNumeric) {
        [array removeLastObject];
    }
}

- (void)showResultForCalculation:(double)value withCompletion:(void (^)(NSString *result))completion {
    NSString *calculation = [NSString stringWithFormat:@"%g", value];
    completion(calculation);
}

- (void)calculateExpressionWithArray:(NSMutableArray *)array withCcompletion:(void (^)(NSNumber *resultNumber))completion {
    [self checkLastItemIsNumericWithArray:array];
    NSNumber *result;
    
    @try {
        NSString *numericExpression = [array componentsJoinedByString:@""];
        NSPredicate *parsed = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"1.0 * %@ = 0", numericExpression]];
        NSExpression *expression = [(NSComparisonPredicate *)parsed leftExpression];
        result = [expression expressionValueWithObject:nil context:nil];
        NSLog(@"Expression: %@", expression);
        NSLog(@"Result: %@", result);
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
        completion(result);
}
@end