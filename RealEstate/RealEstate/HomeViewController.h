//
//  HomeViewController.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"
#import "MyMapView.h"

@interface HomeViewController : UIViewController <HeartPropertyProtocol,CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *userType;

@end
