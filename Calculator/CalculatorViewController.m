//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController() 
@property (readonly) CalculatorBrain *brain;    //Private & ReadOnly Model
@end

@implementation CalculatorViewController

@synthesize display, displayMem, displayOperation, displayTypeOfAngleMetrics;
@synthesize stateForTypeOfAngleMetricsButton;
@synthesize brain;

#pragma mark - Utility Methods

- (BOOL)isDecimalPointValid {
    NSString *myDisplayString = self.display.text;
    NSRange myRange = [myDisplayString rangeOfString:@"."];
    
    if (myRange.length == 0) return YES;
    else return NO;
}


- (void)showAlert {
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Operation" 
                                                      message:self.brain.errorMessage 
                                                     delegate:self 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];

    [myAlert autorelease];
    [myAlert show];

    self.brain.errorMessage = @"";
}


- (NSString *)stringForPendingOperation {
    
    if ([self.brain.waitingOperation isEqual:@"="]) {
            //return self.displayOperation.text = [NSString stringWithFormat:@"Op: = %g ",self.brain.waitingOperand];
        return self.displayOperation.text = [NSString stringWithFormat:@"Op: = %g ",self.brain.waitingOperand];
    } else {
        return self.displayOperation.text = [NSString stringWithFormat:@"Op: %g %@ ",self.brain.waitingOperand, self.brain.waitingOperation];            
            //return self.displayOperation.text = [NSString stringWithFormat:@"Op: %g %@ ",self.brain.waitingOperand, self.brain.waitingOperation];            
    }
}


- (void)updateOptionsDisplays:(UIButton *)mySender {
    //Creates the right setup for Displaying content on all displays on screen
    
    NSString *myOperationDisplayMSG = @"Op: ";
    NSString static *myTypeOfAngleMetricsMSG = @"Rdn";

    //If there is an error when performing an operation, nothing is updaed
    if (![self.brain.errorMessage isEqual:@""]) {
        myOperationDisplayMSG = self.brain.errorMessage;
        //[self showAlert];     //if ussing NSAlertView
        self.brain.errorMessage = @"";
    
    } else {
        //Test Button for testing Error Conditions of the Model calling AlertView
        //Just for testing purposes of NSAlertView
        if ([mySender.titleLabel.text isEqual:@"f"]) {
            [self showAlert];           
        } 
        
        //Checks state of typeOfAngleMetrics Rdn vs Deg and displays correct info on screen
        if ([mySender.titleLabel.text isEqual:@"Deg"] || [mySender.titleLabel.text isEqual:@"Rdn"]) {
            
            //Change image & text of Deg/Rdn Button & Display Text;  
            if (stateForTypeOfAngleMetrics) {                       //Radians
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Rdn"];
                stateForTypeOfAngleMetrics = NO;
                
                [stateForTypeOfAngleMetricsButton setTitle:@"Deg" forState:UIControlStateNormal];
                UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyLight_40.png"];
                [stateForTypeOfAngleMetricsButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
                
            } else {                                                //Degrees
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Deg"];
                stateForTypeOfAngleMetrics = YES;                
                
                [stateForTypeOfAngleMetricsButton setTitle:@"Rdn" forState:UIControlStateNormal];
                UIImage *myButtonImage = [UIImage imageNamed:@"Button_GreyDark_40.png"];
                [stateForTypeOfAngleMetricsButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
            }   
        }
        
        if ([mySender.titleLabel.text isEqual:@"C"]) {
            myOperationDisplayMSG = @"Op: ";
            
        } else {
            if (self.brain.waitingOperand) {
                myOperationDisplayMSG = [self stringForPendingOperation];
            } else {
                myOperationDisplayMSG = [NSString stringWithFormat:@"Op: "];
            }            
        }
    }

    
    //Dsisplays updated content for all the Diplays
    self.displayMem.text = [NSString stringWithFormat:@"Mem: %g", self.brain.myMem];
    self.displayTypeOfAngleMetrics.text = myTypeOfAngleMetricsMSG;
    self.displayOperation.text = myOperationDisplayMSG;
}

#pragma mark - IBAction Methods

- (IBAction)digitPressed:(UIButton *)sender {
    //Performs actions when a Digit (number) is pressed
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqual:@"."]) {
            if ([self isDecimalPointValid]) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        } else {   
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {      
        self.display.text = digit;
        userIsInTheMiddleOfTypingANumber = YES;
    }
}


- (IBAction)operationPressed:(UIButton *)sender {
    //Checks if the user is in the middle of typing some number or its an final result from an operations or equals is pressed        
    if (userIsInTheMiddleOfTypingANumber) {
        self.brain.operand = [self.display.text doubleValue];
        userIsInTheMiddleOfTypingANumber = NO;
    }

    //Evaluate before displaying 
    double result = [self.brain performOperation:sender.titleLabel.text];
    
    if ([CalculatorBrain variablesInExpression:self.brain.expression]) {
	
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
        self.displayOperation.text = @"Op: ";

	} else {
		
        display.text = [NSString stringWithFormat:@"%g", result];
	
    }

    //Update Displays in UI
    [self updateOptionsDisplays:sender];
}


- (IBAction)solvePressed:(id)sender {

    //-- BUG - FUNCIONALIDAD EXTRA PENDIENTE:
    //-- FALLO al introducir operaciones de 1 operando en medio de una expresión,
    //   añade el operando, la operación y el resultado
    
    //If user is in the middle of typing a number when he press solve, set operand
    if (userIsInTheMiddleOfTypingANumber) {
        [self.brain setOperand:[display.text doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
        
    //If not = present at the end of internalExpression
    if (![[CalculatorBrain descriptionOfExpression:self.brain.expression] hasSuffix:@"= "]) {
        [self.brain performOperation: @"="];
    }
        
    //Call evaluateExpression:UssingVariablesValues:
    double myResult = [CalculatorBrain evaluateExpression:self.brain.expression
                                      usingVariableValues:self.brain.myVariables];
    
    //Displays updated content for all the Diplays
    self.display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:self.brain.expression],myResult];
    self.displayOperation.text = @"Op: ";
    
    [self.brain performOperation:@"C"];     //clears everything for next operation
}

- (IBAction)variablePressed:(UIButton *)sender{

    NSString *myOperation = sender.titleLabel.text;
    
    if ([myOperation isEqual:@"Fn"]) {        
        //-- EXTRA CREDIT -- 
        //-- If Fn is Pressed, set/edit the Variable value in Array 
        //  
        
    } else if ([myOperation isEqual:@"z"]) {        //Call SetVariableAsOperand:
        self.display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];

    } else {    //If there is an Variable in expression, displays expression
        
        //if user is typing a number (not zero),multiply the number times the variable, 8x = 8 * X
        if ((userIsInTheMiddleOfTypingANumber) && (![self.display.text isEqual:@"0"])) {
            [self.brain setOperand:[self.display.text doubleValue]];
            [self.brain performOperation:@"*"];
        }

        userIsInTheMiddleOfTypingANumber = NO;
        
        if ([myOperation isEqual:@"x"]) {               //Call SetVariableAsOperand:
            [self.brain setVariableAsOperand:@"x"];
            self.displayOperation.text = @"Op: ";
        
        } else if ([myOperation isEqual:@"a"]) {        //Call SetVariableAsOperand:
            [self.brain setVariableAsOperand:@"a"];
            self.displayOperation.text = @"Op: ";
        
        } else if ([myOperation isEqual:@"b"]) {        //Call SetVariableAsOperand:
            [self.brain setVariableAsOperand:@"b"];
            self.displayOperation.text = @"Op: ";
        }
        
        
        if ([CalculatorBrain variablesInExpression:self.brain.expression]) {
            
            self.display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
            self.displayOperation.text = @"Op: ";
            
        } else {
            //TODO - Pendiente de revisar si sigue funcionando TODO igual
            self.displayOperation.text = @"No Variables in Expression"; 
        }
    }        
}




#pragma mark - View Lifecycle & Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    brain = [[CalculatorBrain alloc] init];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Utility methods for cleaning up  memory when finished
-(void)releaseNilsOfOutlets {
    self.display = nil;
    self.displayMem = nil;
    self.displayOperation = nil;
    self.stateForTypeOfAngleMetricsButton = nil;
}

-(void)releaseMemOfOutlets {
    [display release];
    [displayMem release];
    [displayOperation release];
    [stateForTypeOfAngleMetricsButton release];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseNilsOfOutlets];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // Releasing my own created objects
    [brain release];  
    
    // Releasing my own created IBOutlet objects
    [self releaseMemOfOutlets];
    
    [super dealloc];
}
@end
