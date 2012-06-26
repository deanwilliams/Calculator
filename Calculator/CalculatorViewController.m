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
@property (nonatomic, strong) NSDictionary *testVariableValues;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variableValues = _variableValues;
@synthesize testVariableValues = _testVariableValues;

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

- (void) setTestVariableValues:(NSDictionary *)testVariableValues
{
    _testVariableValues = testVariableValues;
    self.variableValues.text = [self.testVariableValues description];
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

- (IBAction)variablePressed:(UIButton *)sender 
{
    NSString *variable = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:variable];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
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
    //[self addToHistory:operation isOperation:YES];
    double result = [self.brain performOperation:operation usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
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
    //[self addToHistory:self.display.text isOperation:NO];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
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

- (IBAction)updateVariableValues:(UIButton *)sender {
    NSString *text = [sender currentTitle];
    NSDictionary *variableValues;
    if ([text isEqualToString:@"Test 1"]) {
        variableValues = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:5], @"x", [NSNumber numberWithDouble:4.8], @"y", [NSNumber numberWithDouble:0], @"foo", nil];
    } else if ([text isEqualToString:@"Test 2"]) {
        variableValues = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:2], @"x", [NSNumber numberWithDouble:0], @"y", [NSNumber numberWithDouble:10], @"foo", nil];
    } else if ([text isEqualToString:@"Test 3"]) {
        // Do nothing
    }
    self.testVariableValues = variableValues;
}

- (void)viewDidUnload {
    [self setTestVariableValues:nil];
    [super viewDidUnload];
}
@end
