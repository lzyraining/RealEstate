//
//  Property+CoreDataProperties.h
//  RealEstate
//
//  Created by Zhuoyu Li on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Property.h"

NS_ASSUME_NONNULL_BEGIN

@interface Property (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *myUserId;
@property (nullable, nonatomic, retain) NSString *iD;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *address1;
@property (nullable, nonatomic, retain) NSString *address2;
@property (nullable, nonatomic, retain) NSString *zipCode;
@property (nullable, nonatomic, retain) NSString *cost;
@property (nullable, nonatomic, retain) NSString *size;
@property (nullable, nonatomic, retain) NSString *descri;
@property (nullable, nonatomic, retain) NSString *sellerUid;
@property (nullable, nonatomic, retain) NSString *longitutde;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *imagePath;

@end

NS_ASSUME_NONNULL_END
