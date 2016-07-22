//
//  MyFavorCollectionViewCell.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFavorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *address2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeAndSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *addDateLbl;
@property (weak, nonatomic) IBOutlet UITextView *descrip;


@end
