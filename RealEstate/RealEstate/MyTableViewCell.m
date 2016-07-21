//
//  MyTableViewCell.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeBtn_tapped:(id)sender {
    
    _likeBtn.selected = !_likeBtn.selected;
    if (_likeBtn.selected) {
        [self.delegate heartProperty:_likeBtn.tag like:YES];
    }
    else {
        [self.delegate heartProperty:_likeBtn.tag like:NO];
    }
    
}
@end
