//
//  newPostViewController.h
//  RealEstate
//
//  Created by Shuting lang on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "typePopoverViewController.h"


@interface newPostViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,myProtocol>

@property (nonatomic, strong) NSString *prpType;
@property (nonatomic, strong) NSMutableDictionary *crtPrp;
@property BOOL isEdit;

@end
