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
- (NSMutableArray *) programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program
{
    return [self.programStack copy];
}

/*!
    @function pushOperand
    @abstract Push an operand onto the stack
    @discussion
        Push an operand onto the stack.
 */
- (void) pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
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

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"Not yet implemented";
}

+ (double) popOperandOffStack:(NSMutableArray *) stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            // Sum
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            // Subtract
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"*"]) {
            // Multiply
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            // Divide
            double divisor = [self popOperandOffStack:stack];
            if (divisor == 0) {
                result = 0;
            } else {
                if (divisor) result = [self popOperandOffStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            // Sin
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            // Cos
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            // Square Root
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"+ / -"]) {
            result = [self popOperandOffStack:stack] * -1;
        }
    }
    
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

/*!
    @function clearOPerands
    @abstract Clear out the operand stack
    @discussion Completely clear the operand stack
    
 */
- (void) clearOperands
{
    [self.programStack removeAllObjects];
}

@end
