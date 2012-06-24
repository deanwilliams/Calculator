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
- (double) performOperation:(NSString *)operation;
- (void) clearOperands;

@end
