//
//  ViewController.m
//  Tax-Calculator
//
//  Created by Kevin Nguyen on 7/25/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *taxSegmentController;
@property (weak, nonatomic) IBOutlet UILabel *totalTaxedAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountEnteredTextField;


- (IBAction)button:(id)sender;
- (IBAction)taxSegmentControllerSelected:(id)sender;

@end

@implementation ViewController 

float tax = 0.075;
const float CA_TAX = 0.075;
const float CHI_TAX = 0.0925;
const float NY_TAX = 0.045;
const float TX_TAX = 0.0825;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1.0];
    
    self.amountEnteredTextField.delegate = self;
    _amountEnteredTextField.placeholder = @"Enter amount";
    _amountEnteredTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _amountEnteredTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _totalTaxedAmountLabel.text = @"Enter amount below";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)button:(id)sender {

    float enteredAmount = [_amountEnteredTextField.text floatValue];
    _totalTaxedAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", enteredAmount + (enteredAmount * tax)];
}

- (IBAction)taxSegmentControllerSelected:(id)sender {
    
    switch (self.taxSegmentController.selectedSegmentIndex)
    {
        case 0:
            tax = CA_TAX;
            NSLog(@"tax = : %f", tax);
            break;
        case 1:
            tax = CHI_TAX;
            NSLog(@"tax = : %f", tax);
            break;
        case 2:
            tax = NY_TAX;
            NSLog(@"tax = : %f", tax);
            break;
        case 3:
            tax = TX_TAX;
            NSLog(@"tax = : %f", tax);
            break;
        default:
            tax = CA_TAX;
            NSLog(@"tax = : %f", tax);
            break;
    }
}
/*
 When RETURN from keyboard is tapped - perform tax calculations
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    float enteredAmount = [_amountEnteredTextField.text doubleValue];
    _totalTaxedAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", enteredAmount + (enteredAmount * tax)];
    [textField resignFirstResponder];
    return YES;
}

/*
 This will hide the clear the text field when tapped
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField selectAll:nil];
}

/*
 This will hide the keyboard when tapped outside number pad
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
