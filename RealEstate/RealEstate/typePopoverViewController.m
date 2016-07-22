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
- (IBAction)plot_Tapped:(UIButton *)sender;
- (IBAction)flat_Tapped:(UIButton *)sender;
- (IBAction)house_Tapped:(UIButton *)sender;
- (IBAction)office_Tapped:(UIButton *)sender;
- (IBAction)villa_Tapped:(UIButton *)sender;

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

- (IBAction)plot_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setPrpType:@"Plot"];
    }];
}

- (IBAction)flat_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setPrpType:@"Flat"];
    }];
}

- (IBAction)house_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setPrpType:@"House"];
    }];
}

- (IBAction)office_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setPrpType:@"Office"];
    }];
}

- (IBAction)villa_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setPrpType:@"Villa"];
    }];
}

@end
