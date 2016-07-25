//
//  MyPostViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "MyPostViewController.h"
#import "newPostViewController.h"
#import <MapKit/MapKit.h>


@interface MyPostViewController () <CLLocationManagerDelegate>
{

    CLGeocoder *geocoder;
    NSString *addr;

}
- (IBAction)backBtn_Tapped:(UIButton *)sender;
- (IBAction)prpCorrectBtn_Tapped:(UIButton *)sender;
- (IBAction)srchBtn_Tapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *addr1TF;
@property (weak, nonatomic) IBOutlet UITextField *suitTF;
@property (weak, nonatomic) IBOutlet UITextField *stateTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet MKMapView *myMap;


@end

@implementation MyPostViewController

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

- (IBAction)backBtn_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)prpCorrectBtn_Tapped:(UIButton *)sender {
    
    newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)srchBtn_Tapped:(UIButton *)sender {
    
    geocoder = [[CLGeocoder alloc]init];
    [self getCoordinateByAddress:addr];
    
}

-(void)getCoordinateByAddress:(NSString *)address{
    
    addr = [NSString stringWithFormat:@"%@,%@,%@,%@",self.addr1TF.text,self.suitTF.text,self.stateTF.text,self.zipTF.text];
    [geocoder geocodeAddressString:addr completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;
        CLRegion *region=placemark.region;
        NSDictionary *addressDic= placemark.addressDictionary;
    }];
}

@end
