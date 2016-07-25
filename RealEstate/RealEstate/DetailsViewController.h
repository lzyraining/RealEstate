//
//  DetailsViewController.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/24/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *propertyId;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *sellerUid;

@end
