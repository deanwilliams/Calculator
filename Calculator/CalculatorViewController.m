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
@synthesize variableDisplay = _variableDisplay;
@synthesize testVariableValues = _testVariableValues;

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

// Get the model
- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

// Get our variable values
- (NSDictionary *) testVariableValues
{
    if (!_testVariableValues) {
		_testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:0], @"x",
                               [NSNumber numberWithDouble:4.8], @"y",
                               [NSNumber numberWithDouble:0], @"foo", nil];
	}
	return _testVariableValues;
}

// A digit button has been pressed
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

// A variable button has been pressed
- (IBAction)variablePressed:(UIButton *)sender 
{
    NSString *variable = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:variable];
    [self synchronizeView];
}

// Append the string to the display
- (void) appendToDisplay:(NSString *)digit
{
    self.display.text = [self.display.text stringByAppendingString:digit];
}

// Check to see if the number being currently entered contains a decimal point
- (BOOL)alreadyContainsDecimalPoint
{
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

// An operation button has been pressed
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
    [self.brain pushOperation:operation];
    [self synchronizeView];
}

// Synchronise all the things!
-(void)synchronizeView {
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];

	// Find the result by running the program passing in the test variable values
    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues]];
    
    NSString *variableDescription = @"";
    NSDictionary *variablesUsed = [self programVariableValues];
    for (NSString *key in [variablesUsed keyEnumerator]) {
        NSNumber *value = [variablesUsed objectForKey:key];
        if ([value isEqual:[NSNull null]]) value = [NSNumber numberWithDouble:0];
        variableDescription = [variableDescription stringByAppendingFormat:@"%@ = %g  ", key, [value doubleValue]];
    }
    self.variableDisplay.text = variableDescription;
    
	// And the user isn't in the middle of entering a number
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

// Get a dictionary of variables actaully used in the program
- (NSDictionary *)programVariableValues {   
    
	// Find the variables in the current program in the brain as an array
	NSArray *variableArray = 
	[[CalculatorBrain variablesUsedInProgram:self.brain.program] allObjects];
    
	// Return a description of a dictionary which contains keys and values for the keys 
	// that are in the variable array
	return [self.testVariableValues dictionaryWithValuesForKeys:variableArray];
}

// Enter button has been pressed
- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self synchronizeView];
}

// Clear out the program stack
- (IBAction)clear:(UIButton *)sender 
{
    [self.brain clearOperands];
    [self synchronizeView];	
}

// Remove an incorrect digit
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

// Update currently set variable values
- (IBAction)updateVariableValues:(UIButton *)sender {
    NSString *text = [sender currentTitle];
    if ([text isEqualToString:@"Test 1"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:-4], @"x",
                                   [NSNumber numberWithDouble:3], @"y",
                                   [NSNumber numberWithDouble:4], @"foo", nil];
    } else if ([text isEqualToString:@"Test 2"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:-5], @"x", nil];
    } else if ([text isEqualToString:@"Test 3"]) {
        self.testVariableValues = nil;  
    }
    [self synchronizeView];
}

- (void)viewDidUnload {
    [self setTestVariableValues:nil];
    [super viewDidUnload];
}
@end
