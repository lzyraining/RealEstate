//
//  CustListTableViewCell.h
//  RealEstate
//
//  Created by Shuting lang on 7/27/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *addr1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *addr2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *typeSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;
@property (weak, nonatomic) IBOutlet UILabel *addDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *editLbl;
@property (weak, nonatomic) IBOutlet UILabel *swipeLbl;


@end
