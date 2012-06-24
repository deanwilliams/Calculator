//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dean Williams on 21/06/2012.
//  Copyright (c) 2012 Novatech. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

/*!
    @function operandStack
    @abstract Getter for the operand stack
    @discussion
        Getter for the operand stack.
        This will initialise the operand stack if it is nil
 */
- (NSMutableArray *) operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
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
    @function popOperand
    @abstract Pop and operand off the stack
    @discussion
        Pop an operand off the stack. If it's the last object of
        the stack then completely clear it.
 */
- (double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
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
    
    [self pushOperand:result];
    
    return result;
}

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
