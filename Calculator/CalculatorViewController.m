//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Dean Williams on 20/06/2012.
//  Copyright (c) 2012 Novatech. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

/*!
    @function brain
    @abstract Getter method for this controller's model.
    @discussion
        Getter method for the this controller's model.
 */
- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

/*!
    @function digitPressed
    @abstract A digit button has been pressed
    @discussion
        A digit button has been pressed.
 */
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([digit isEqualToString:@"."]) {
            if (![self alreadyContainsDecimalPoint]) {
                [self appendToDisplay:digit];
            }
        } else {
            [self appendToDisplay:digit];
        }
    } else {
        if ([self.display.text isEqualToString:@"0"] && [digit isEqualToString:@"."]) {
            [self appendToDisplay:digit];
        } else {
            self.display.text = digit;
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

/*!
    @function appendToDisplay
    @abstract Append the variable to the display text
    @discussion
        Append the variable to the display text.
 */
- (void) appendToDisplay:(NSString *)digit
{
    self.display.text = [self.display.text stringByAppendingString:digit];
}

/*!
    @function alreadyContainsDecimalPoint
    @abstract Check if the display text already contains a decimal point
    @discussion
        Check if the display string already contains decimal point.
 */
- (BOOL)alreadyContainsDecimalPoint
{
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/*!
    @function operationPressed
    @abstract An operation button has been pressed
    @discussion
        An operation button has been pressed.
        If the user has not pressed the enter button from entering the last
        number then "enter" it for them.
 */
- (IBAction)operationPressed:(UIButton *)sender 
{
    NSString *operation = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([operation isEqualToString:@"+ / -"]) {
            double value = [self.display.text doubleValue];
            value = value * -1;
            self.display.text = [NSString stringWithFormat:@"%g", value];
            return;
        } else {
            [self enterPressed];
        }
    }
    [self addToHistory:operation isOperation:YES];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

/*!
    @function enterPressed
    @abstract The enter button has been pressed
    @discussion
        The enter button has been pressed so push the operand onto the stack,
        and then add the operand to the stack and the display history
 */
- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self addToHistory:self.display.text isOperation:NO];
}

/*!
    @function addToHistory
    @abstract Add the variable to the history UILabel
    @discussion
        Add the provided variable to the history UI label.
 */
- (void) addToHistory:(NSString *) digit isOperation:(BOOL) isOperation
{
    if ([self.history.text rangeOfString:@" ="].location != NSNotFound) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 2];
    }
    if ([self.history.text length] == 0) {
        self.history.text = [self.history.text stringByAppendingString:digit];
    } else {
        self.history.text = [self.history.text stringByAppendingString:@" "];
        self.history.text = [self.history.text stringByAppendingString:digit];
    }
    if (isOperation) {
        self.history.text = [self.history.text stringByAppendingString:@" ="];
    }
}

/*!
    @function clear
    @abstract The clear button has been pressed
    @discussion
        The clear button has been pressed so reset the displays
        and call the model to clear the operand stack
 */
- (IBAction)clear:(UIButton *)sender 
{
    self.display.text = @"0";
    self.history.text = @"";
    [self.brain clearOperands];
}

/*!
    @function backspacePressed
    @abstract Backspace key pressed
    @discussion
        Backspace key has been pressed so remove the last digit entered
 */
- (IBAction)backspacePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text length] == 1) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            NSString *newDigit = [self.display.text substringToIndex:[self.display.text length] - 1];
            self.display.text = newDigit;
        }
    }
}

@end
