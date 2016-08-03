//
//  ViewController.m
//  Silver-Calculator
//
//  Created by Kevin Nguyen on 8/1/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

#import "ViewController.h"

typedef enum {ADD, SUBTRACT, MULTIPLY, DIVIDE} Calculator;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
- (IBAction)segmentControllerSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *operandLabel;

@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)sliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end

@implementation ViewController

Calculator operation;


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)segmentControllerSelected:(id)sender {
    switch (self.segmentController.selectedSegmentIndex)
    {
        case 1:
            operation = SUBTRACT;
            self.operandLabel.text = @"-";
            break;
        case 2:
            operation = MULTIPLY;
            self.operandLabel.text = @"✕";
            break;
        case 3:
            operation = DIVIDE;
            self.operandLabel.text = @"÷";
            break;
        default:
            operation = ADD;
            self.operandLabel.text = @"+";
            break;
    }
    self.totalLabel.text = [self calculate:_textField.text andSliderValue:_slider.value];
}

- (IBAction)sliderChanged:(id)sender {

    self.sliderLabel.text = [NSString stringWithFormat:@"%f", self.slider.value];
    self.totalLabel.text = [self calculate:_textField.text andSliderValue:_slider.value];
}

- (NSString*) calculate:(NSString *)textFieldText andSliderValue:(float)slider {
    
    NSString *result;
    float value;
    
    switch (operation) {
        case ADD:
            value = _textField.text.floatValue + _slider.value;
            break;
        case SUBTRACT:
            value = _textField.text.floatValue - _slider.value;
            break;
        case MULTIPLY:
            value = _textField.text.floatValue * _slider.value;
            break;
        case DIVIDE:
            value = _textField.text.floatValue / _slider.value;
            break;
        default:
            break;
    }
    result = [NSString stringWithFormat:@"%f", value];
    return result;
}

#pragma mark - UITextFieldDelegate
/*
 This will hide the keyboard when tapped outside number pad
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
