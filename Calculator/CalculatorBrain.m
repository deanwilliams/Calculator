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

// Getter for the program stack. Lazily initialise if nil
- (NSMutableArray *) programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

// Public method to get a copy of the program stack
- (id) program
{
    return [self.programStack copy];
}

// Push an operand onto the stack
- (void) pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

// Push a variable onto the stack
- (void) pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

// Push an operation onto the stack then calculate the result
// This method has been superceded
- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

// Push an operation onto the stack
- (void) pushOperation:(NSString *) operation
{
    [self.programStack addObject:operation];
}

// Class method to get a nicely formatted string description of the program stack
+ (NSString *) descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSString *strDesc = @"";
    
    if ([program isKindOfClass:[NSArray class]]) {
        // Make a consumable, mutable copy:
        stack = [program mutableCopy];
    }
    
    while (stack.count) {
        strDesc = [strDesc stringByAppendingString:[self descriptionOfTopOfStack:stack]];
        if (stack.count) {
            // More statements still on stack. We will loop again, but first, append comma separator:
            strDesc = [strDesc stringByAppendingString:@", "];
        }
    }
    
    return strDesc;
}

// Use recursion to build the string description of the program stack
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSMutableString *programFragment = [NSMutableString stringWithString:@""];
    
    // Take an object off the top of the stack
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject]; // ... and consume it
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        // If it's a number just return it
        [programFragment appendFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([self isDoubleOperandOperation:topOfStack]) {
            // +, -, * or /
            NSString *secondOperation = [self descriptionOfTopOfStack:stack];
            NSString *firstOperation = [self descriptionOfTopOfStack:stack];
            
            if ([topOfStack isEqualToString:@"+"] || 
                [topOfStack isEqualToString:@"-"]) {
                [programFragment appendFormat:@"(%@ %@ %@)", [self deBracket:firstOperation], topOfStack, [self deBracket:secondOperation]];
            } else {
                [programFragment appendFormat:@"%@ %@ %@", firstOperation, topOfStack, secondOperation];
            }
        } else if ([self isSingleOperandOperation:topOfStack]) {
            // Square root, sin or cos
            [programFragment appendFormat:@"%@(%@)", topOfStack, [self deBracket:[self descriptionOfTopOfStack:stack]]];
        } else if ([ self isNoOperandOperation:topOfStack]) {
            // Pi
            [programFragment appendFormat:@"%@", topOfStack];
        } else if ([self isVariable:topOfStack]) {
            [programFragment appendFormat:@"%@", topOfStack];
        }
    }
    
    return programFragment;
}

// Attemot to remove some unnecesary parentheses
+ (NSString *)deBracket:(NSString *)expression {
    
    NSString *description = expression;
    
    // Check to see if there is a bracket at the start and end of the expression
    // If so, then strip the description of these brackets and return.
    if ([expression hasPrefix:@"("] && [expression hasSuffix:@")"]) {
        description = [description substringFromIndex:1];
        description = [description substringToIndex:[description length] - 1];
    }  
    
    // Also need to do a final check, to cover the case where removing the brackets
    // results in a + b) * (c + d. Have a look at the position of the brackets and
    // if there is a ) before a (, then we need to revert back to expression
    NSRange openBracket = [description rangeOfString:@"("];
    NSRange closeBracket = [description rangeOfString:@")"];
    
    if (openBracket.location <= closeBracket.location) return description;
    else return expression; 
}

// Is the string a double operand operation?
+ (BOOL) isDoubleOperandOperation:(NSString *) operation
{
    if ([operation isEqualToString:@"+"] || [operation isEqualToString:@"-"] || [operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) {
        return YES;
    } else {
        return NO;
    }
}

// Is the string a single operand operation?
+ (BOOL) isSingleOperandOperation:(NSString *) operation
{
    if ([operation isEqualToString:@"sin"] || [operation isEqualToString:@"cos"] || [operation isEqualToString:@"sqrt"]) {
        return YES;
    } else {
        return NO;
    }
}

// Is the string a no operand operation?
+ (BOOL) isNoOperandOperation:(NSString *) operation
{
    if ([operation isEqualToString:@"π"]) {
        return YES;
    } else {
        return NO;
    }
}

// Use recursion to work through the stack abd calculate the result
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
            result = cos([self popOperandOffStack:stack] );
        } else if ([operation isEqualToString:@"sqrt"]) {
            // Square Root
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            // Pi
            result = M_PI;
        } else if ([operation isEqualToString:@"+ / -"]) {
            // Negate the value
            result = [self popOperandOffStack:stack] * -1;
        } 
    }
    
    return result;
}

// Superceded method. Call the new method with nil values for the variables dictionary
+ (double) runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

// Run the program and calculate the result
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *) variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    // For each item in the program
    for (int i=0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i]; 
        
        // See whether we think the item is a variable
        if ([obj isKindOfClass:[NSString class]] && [[self class] isVariable:obj]) {
            id value = [variableValues objectForKey:obj];         
            // If value is not an instance of NSNumber, set it to zero
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0];
            }        
            // Replace program variable with value.
            [stack replaceObjectAtIndex:i withObject:value];
        }     
    }  
    return [self popOperandOffStack:stack];
}

// Calculate a set of variables used within the program stack
+ (NSSet *) variablesUsedInProgram:(id) program
{
    NSArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program copy];
    }
    NSMutableSet *variablesUsed = [[NSMutableSet alloc] init];
    for (id term in stack) {
        if ((![term isKindOfClass:[NSNumber class]] && [self isVariable:term])) {
            [variablesUsed addObject:(NSString *)term];
        }
    }
    NSSet *returnSet = nil;
    if (variablesUsed.count > 0) {
        returnSet = [variablesUsed copy];
    }
    return returnSet;
}

// Is the string a variable?
+ (BOOL) isVariable:(NSString *) term
{
    if ([term isEqualToString:@"x"] || [term isEqualToString:@"y"] || [term isEqualToString:@"foo"]) {
        return YES;
    } else {
        return NO;
    }
}

// Clear the program stack
- (void) clearOperands
{
    [self.programStack removeAllObjects];
}

@end
