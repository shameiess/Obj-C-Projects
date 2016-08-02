#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *taxSegmentController;
@property (weak, nonatomic) IBOutlet UILabel *totalTaxedAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountEnteredTextField;

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
    [self setup];
}

- (void)setup {
    _amountEnteredTextField.placeholder = @"Enter amount";
    _amountEnteredTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _amountEnteredTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _totalTaxedAmountLabel.text = @"Enter amount below";
}

- (IBAction)taxSegmentControllerSelected:(id)sender {
    switch (self.taxSegmentController.selectedSegmentIndex)
    {
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
    
    self.totalTaxedAmountLabel.text = [self calculateTaxWith:_amountEnteredTextField.text andTaxValue:tax];
}

#pragma mark - Private Methods
- (NSString *)calculateTaxWith:(NSString *)textFieldText andTaxValue:(float)tax {
    
    NSString *result = [NSString stringWithFormat:@"$%.2f", textFieldText.floatValue + (textFieldText.floatValue * tax)];
    return result;
}

#pragma mark - UITextFieldDelegate
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