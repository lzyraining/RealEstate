//
//  HomeViewController.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"

@interface HomeViewController : UIViewController <HeartPropertyProtocol> 

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *userType;

@end
