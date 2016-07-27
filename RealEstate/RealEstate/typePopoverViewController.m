//
//  typePopoverViewController.m
//  RealEstate
//
//  Created by Shuting lang on 7/22/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "typePopoverViewController.h"
#import "newPostViewController.h"

@interface typePopoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *plot_outlet;
@property (weak, nonatomic) IBOutlet UIButton *flat_outlet;
@property (weak, nonatomic) IBOutlet UIButton *house_outlet;
@property (weak, nonatomic) IBOutlet UIButton *office_outlet;
@property (weak, nonatomic) IBOutlet UIButton *villa_outlet;
- (IBAction)prpTypeBtn_Tapped:(UIButton *)sender;

- (IBAction)doneBtn_Tapped:(UIButton *)sender;

@end

@implementation typePopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)prpTypeBtn_Tapped:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (sender.tag) {
        case 101:
            [defaults setValue:@"plot" forKey:@"prpType"];
            break;
        case 102:
            [defaults setValue:@"villa" forKey:@"prpType"];
            break;
        case 103:
            [defaults setValue:@"flat" forKey:@"prpType"];
            break;
        case 104:
            [defaults setValue:@"office" forKey:@"prpType"];
            break;
        case 105:
            [defaults setValue:@"house" forKey:@"prpType"];
            break;
        default:
            break;
    }
    if ([self protocol]) {
        [self.protocol setPrpType:[defaults valueForKey:@"prpType"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)doneBtn_Tapped:(UIButton *)sender {
}
@end
