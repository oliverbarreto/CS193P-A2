//
//  CalculatorBrain.h
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject {

@private
    double operand;                 //Standard CalculatorBrain iVars
    double myMem;                   //Basic Memory Operations
    double waitingOperand;          //to keep track of waiting operation when you try 

    BOOL typeOfAngleMetrics;        //FALSE=Degrees;TRUE=Radians

    NSString *waitingOperation;     //to do something like "2 + 3 * 5 ="
    NSString *errorMessage;          //Sends Warning & Error Messages to ViewController
}

//Basic Model Properties
@property double operand, myMem, waitingOperand;
@property BOOL typeOfAngleMetrics;
@property (nonatomic, retain) NSString *waitingOperation;
@property (nonatomic, retain) NSString *errorMessage;


//Basic Model Methods
- (double)performOperation:(NSString *)operation;   //Basic Operations Management


@end
