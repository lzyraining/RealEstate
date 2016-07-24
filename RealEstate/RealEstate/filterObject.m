//
//  filterObject.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/23/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "filterObject.h"

@implementation filterObject

-(id)init {
    self = [super init];
    self.type = @"";
    self.category = @"";
    self.costMin = @"";
    self.costMax = @"";
    self.address = @"";
    return self;
}

@end
