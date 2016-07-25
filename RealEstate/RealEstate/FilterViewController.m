//
//  FilterViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/23/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSeg;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn;
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UITextField *costFromTextField;
@property (weak, nonatomic) IBOutlet UITextField *costToTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressText;

- (IBAction)confirmBtn_tapped:(id)sender;
- (IBAction)categoryTypeBtn_tapped:(id)sender;
- (IBAction)clearBtn_tapped:(id)sender;

@end

@implementation FilterViewController

@synthesize fObject = _fObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    if ([_fObject.type isEqualToString:@""]) {
        _typeSeg.selectedSegmentIndex = 0;
    }
    else if ([_fObject.type isEqualToString:@"Plot"]) {
        _typeSeg.selectedSegmentIndex = 1;
    }
    else if ([_fObject.type isEqualToString:@"Flat"]) {
        _typeSeg.selectedSegmentIndex = 2;
    }
    else if ([_fObject.type isEqualToString:@"House"]) {
        _typeSeg.selectedSegmentIndex = 3;
    }
    else if ([_fObject.type isEqualToString:@"Offices"]) {
        _typeSeg.selectedSegmentIndex = 4;
    }
    else if ([_fObject.type isEqualToString:@"Villa"]) {
        _typeSeg.selectedSegmentIndex = 5;
    }
    
    if([_fObject.category isEqualToString:@"1"]) {
        _rentBtn.selected = YES;
    }
    else if ([_fObject.category isEqualToString:@"2"]){
        _saleBtn.selected = YES;
    }
    else {
        _rentBtn.selected = NO;
        _saleBtn.selected = NO;
    }
    _costFromTextField.text = _fObject.costMin;
    _costToTextField.text = _fObject.costMax;
    _addressText.text = _fObject.address;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmBtn_tapped:(id)sender {
    
    if ([_costFromTextField.text doubleValue] > [_costFromTextField.text doubleValue]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Maxmium price must be larger than minimium price" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        if (_typeSeg.selectedSegmentIndex == 0) {
            _fObject.type = @"";
        }
        else if (_typeSeg.selectedSegmentIndex == 1) {
            _fObject.type = @"Plot";
        }
        else if (_typeSeg.selectedSegmentIndex == 2) {
            _fObject.type = @"Flat";
        }
        else if (_typeSeg.selectedSegmentIndex == 3) {
            _fObject.type = @"House";
        }
        else if (_typeSeg.selectedSegmentIndex == 4) {
            _fObject.type = @"Offices";
        }
        else {
            _fObject.type = @"Villa";
        }
        
        if (!_rentBtn.selected && !_saleBtn.selected) {
            _fObject.type = @"";
        }
        else {
            if (_rentBtn.selected) {
                _fObject.category = @"1";
            }
            else {
                _fObject.category = @"2";
            }
        }
        
        _fObject.costMin = _costFromTextField.text;
        _fObject.costMax = _costToTextField.text;
        _fObject.address = _addressText.text;
        
        if(self.delegate) {
            [self.delegate submitFilterContidiotn];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)categoryTypeBtn_tapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 0) {
        _rentBtn.selected = !_rentBtn.selected;
        _saleBtn.selected = NO;
    }
    else {
        _rentBtn.selected = NO;
        _saleBtn.selected = !_saleBtn.selected;
    }
}

- (IBAction)clearBtn_tapped:(id)sender {
    _typeSeg.selectedSegmentIndex = 0;
    _rentBtn.selected = NO;
    _saleBtn.selected = NO;
    _costFromTextField.text = @"";
    _costToTextField.text = @"";
    _addressText.text = @"";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_costToTextField resignFirstResponder];
    [_costFromTextField resignFirstResponder];
    [_addressText resignFirstResponder];
}
@end
