//
//  MyPostViewController.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface MyPostViewController : UIViewController <UIGestureRecognizerDelegate,MKAnnotation,MKMapViewDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, strong) NSMutableDictionary* currentPrp;
@property BOOL isEdit;

@end
