//
//  MyTableViewCell.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeartPropertyProtocol <NSObject>

-(void)heartProperty: (NSInteger) index like: (BOOL) like;

@end

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *propertyCateLbl;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
- (IBAction)likeBtn_tapped:(id)sender;

@property (strong, nonatomic) id<HeartPropertyProtocol>delegate;
@end
