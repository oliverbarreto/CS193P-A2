Completed:
- Required:
	- A2.1: I already have everything using properties in my model, even my Brain as a private property since Calculator A1

	- A2.2: Fixed all Memory Problems since Calculator A1

	- A2.1 - A2.5: Fully Functional


- Extra Credit:
	- A2.1: All my IBOutlets work as properties & they are dealloc and set to nil en ViewDidUnload
	- A2.2: Init brain in ViewDidLoad, not lazy instanciated, in Controller

	- Added 1: 	Exp: shows an UIAlertView with current expression
				Vars: shows an UIAlertView with current values of variables
				Fn: edit mode for setting variable values
				
 

Known Bugs:
	- None !!!
	- Functionallity bug: 
		- operations of 1 operands do not show correctly because of not using parenthesis, but work fine
		- 


Assignment 2:

Required Tasks

1. Update your Calculator’s code to use properties wherever possible, including (but not necessarily limited to) UILabel’s text property and UIButton’s textLabel property as well as using a private property for your brain in your Controller.

2. Fix the memory management problems we had in last week’s version of the Calculator, including the Model not getting released in the Controller’s dealloc and the leaks associated with waitingOperation.

3. Implement this API for your CalculatorBrain so that it functions as described in the following sections. You may need additional instance variables.
    @interface CalculatorBrain : NSObject
    {
        double operand;
        NSString *waitingOperation;
        double waitingOperand;
}
    - (void)setOperand:(double)aDouble;
    - (void)setVariableAsOperand:(NSString *)variableName;
    - (double)performOperation:(NSString *)operation;
    @property (readonly) id expression;
    + (double)evaluateExpression:(id)anExpression
             usingVariableValues:(NSDictionary *)variables;
    + (NSSet *)variablesInExpression:(id)anExpression;
    + (NSString *)descriptionOfExpression:(id)anExpression;
    + (id)propertyListForExpression:(id)anExpression;
    + (id)expressionForPropertyList:(id)propertyList;
    @end

4. Modify your CalculatorViewController to add a target/action method which calls setVariableAsOperand: above with the title of the button as the argument. Add at least 3 different variable buttons (e.g. “x”, “a” and “b”) in Interface Builder and hook them up to this method.

5. Add a target/action method to CalculatorViewController which tests your CalculatorBrain class by calling evaluateExpression:usingVariableValues: with your Model CalculatorBrain’s current expression and an NSDictionary with a test set of variable values (e.g. the first variable set to 2, the second to 4, etc.). Create a button in your interface and wire it up to this method. The result should appear in the display.



Extra Credit Tasks

1. Create@propertystatements(withcorresponding@synthesizestatements)forallof your IBOutlet instance variables in your Controller, then set them all to nil in your viewDidUnload. This will be required on all future assignments, so this is a good opportunity to practice it.

2. Instead of lazily instantiating your Model in your Controller, create it in a method in your Controller named viewDidLoad (it is called as soon as your Interface Builder file is finished loading). Then you can remove your brain method in your Controller and just use the instance variable brain directly.

