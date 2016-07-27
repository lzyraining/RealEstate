//
//  typePopoverViewController.h
//  RealEstate
//
//  Created by Shuting lang on 7/22/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myProtocol<NSObject>

-(void)setPrpType:(NSString *)type;

@end
@interface typePopoverViewController : UIViewController
@property(nonatomic,assign)id<myProtocol>protocol;


@end
