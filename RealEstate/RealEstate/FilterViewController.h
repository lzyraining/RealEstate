//
//  FilterViewController.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/23/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "filterObject.h"

@protocol filterObjectProtocol <NSObject>

-(void)submitFilterContidiotn;

@end

@interface FilterViewController : UIViewController

@property (strong, nonatomic) filterObject *fObject;
@property (strong, nonatomic) id <filterObjectProtocol> delegate;

@end
