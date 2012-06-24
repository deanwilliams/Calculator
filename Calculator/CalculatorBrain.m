//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dean Williams on 21/06/2012.
//  Copyright (c) 2012 Novatech. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

/*!
    @function operandStack
    @abstract Getter for the operand stack
    @discussion
        Getter for the operand stack.
        This will initialise the operand stack if it is nil
 */
- (NSMutableArray *) operandStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

/*!
    @function pushOperand
    @abstract Push an operand onto the stack
    @discussion
        Push an operand onto the stack.
 */
- (void) pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

/*!
    @function performOperation
    @abstract Perform a mathematical operation
    @discussion 
        Perform a mathematical operation. 
        Supported operations are sum, subtract, divide,
        sin, cos, square root and pi
 
        If the operand would result in an invalid result (like divide by zero)
        then zero is returned as the result
 */
- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
    
}

/*
    double result = 0;
    // Calculate result
    if ([operation isEqualToString:@"+"]) {
        // Sum
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        // Subtract
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"*"]) {
        // Multiply
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        // Divide
        double divisor = [self popOperand];
        if (divisor == 0) {
            result = 0;
        } else {
            if (divisor) result = [self popOperand] / divisor;
        }
    } else if ([operation isEqualToString:@"sin"]) {
        // Sin
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        // Cos
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        // Square Root
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"+ / -"]) {
        result = [self popOperand] * -1;
    }
 */

/*!
    @function clearOPerands
    @abstract Clear out the operand stack
    @discussion Completely clear the operand stack
    
 */
- (void) clearOperands
{
    [self.operandStack removeAllObjects];
}

@end
