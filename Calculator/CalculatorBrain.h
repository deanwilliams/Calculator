//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Dean Williams on 21/06/2012.
//  Copyright (c) 2012 Novatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (void) pushVariable:(NSString *)variable;
- (void) pushOperation:(NSString *) operation;
- (double) performOperation:(NSString *)operation;
- (void) clearOperands;

@property (readonly) id program;

+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *) descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
