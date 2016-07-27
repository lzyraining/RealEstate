//
//  MyPostViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "MyPostViewController.h"
#import "newPostViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface MyPostViewController ()
{

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
@property (weak, nonatomic) IBOutlet UIButton *srchBtn_outlet;
@property (weak, nonatomic) IBOutlet UIButton *corrctBtn_Outlet;


@end

@implementation MyPostViewController
@synthesize locationManager,currentPrp,isEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myMap.delegate = self;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for 2 seconds
    [self.myMap addGestureRecognizer:lpgr];
    if (currentPrp) {
        self.addr1TF.text = [currentPrp valueForKey:@"Property Address1"];
    }
    self.srchBtn_outlet.layer.cornerRadius = 10.0;
    self.corrctBtn_Outlet.layer.cornerRadius = 10.0;
    
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMap];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.myMap convertPoint:touchPoint toCoordinateFromView:self.myMap];
    
    NSArray *annotations = [self.myMap annotations];
    for (id annotation in annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        [self.myMap removeAnnotation:annotation];
    }
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.myMap addAnnotation:annot];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:annot.coordinate.latitude longitude:annot.coordinate.longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         self.addr1TF.text = [NSString stringWithFormat:@"%@",placemark.name];
         self.zipTF.text = [NSString stringWithFormat:@"%@",placemark.postalCode];
         self.stateTF.text = [NSString stringWithFormat:@"%@",placemark.locality];
     }];

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
    
    if ([self.addr1TF.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Cant submit diet due to unknown error" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
    
        NSArray *arr = [self.myMap annotations];
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot = [arr objectAtIndex:0];
        NSString *lat = [NSString stringWithFormat:@"%f",annot.coordinate.latitude];
        NSString *lon = [NSString stringWithFormat:@"%f",annot.coordinate.longitude];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:lat forKey:@"prplat"];
        [defaults setValue:lon forKey:@"prplon"];
        newPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"newPostViewController"];
        [controller setCrtPrp:currentPrp];
        [controller setIsEdit:isEdit];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}

- (IBAction)srchBtn_Tapped:(UIButton *)sender {
    
    addr = [NSString stringWithFormat:@"%@,%@,%@,%@",self.addr1TF.text,self.suitTF.text,self.stateTF.text,self.zipTF.text];
    [self reverseAddressGeocoder:addr];
    
}

-(MKPointAnnotation *)reverseAddressGeocoder:(NSString*)address{
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];

    //NSString *addrTest = @"1840 wessel ct";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if (placemarks && [placemarks count]>0) {
                CLPlacemark *place = [placemarks lastObject];
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:place];
                NSArray *annotations = [self.myMap annotations];
                for (id annotation in annotations) {
                    if ([annotation isKindOfClass:[MKUserLocation class]]) {
                        continue;
                    }
                    [self.myMap removeAnnotation:annotation];
                }
                point.coordinate = placemark.coordinate;
                [self.myMap addAnnotation:point];
                
                MKCoordinateRegion region;
                MKCoordinateSpan span;
                span.latitudeDelta = 0.01;
                span.longitudeDelta = 0.01;
                region.span = span;
                region.center = point.coordinate;
            
                [self.myMap setRegion:region animated:TRUE];
                [self.myMap regionThatFits:region];
                
            }
        }
        else {
            NSLog(@"Error: %@",[error description]);
        }
    }];
    
    return point;
}

@end
