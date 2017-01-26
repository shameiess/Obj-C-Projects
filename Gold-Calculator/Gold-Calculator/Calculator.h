//
//  Calculator.h
//  Gold-Calculator
//
//  Created by Kevin Nguyen on 8/23/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject
typedef void(^CompletionBlock)(BOOL success, NSData * response, NSError * error );

//- (double)performCalculation:(NSString *)calculation;
//+ (double)calculate:(id)calc;

- (NSNumber *)calculateExpressionWithCalculationArray:(NSMutableArray *)array;
- (void) checkLastItemIsNumericWithArray:(NSMutableArray *)array;
//- (NSString *)showResultForCalculationWithValue:(double)value;
- (void)showResultForCalculation:(double)value withCompletion:(void (^)(NSString *result))completion;
- (void)calculateExpressionWithArray:(NSMutableArray *)array withCcompletion:(void (^)(NSNumber *resultNumber))completion;

@property (nonatomic, assign) NSString *result;

@end