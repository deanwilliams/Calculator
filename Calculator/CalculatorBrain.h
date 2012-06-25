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
- (double) performOperation:(NSString *)operation;
- (double) performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues;
- (void) clearOperands;

@property (readonly) id program;

+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *) descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
