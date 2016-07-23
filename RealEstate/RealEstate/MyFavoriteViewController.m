//
//  MyFavoriteViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "AppDelegate.h"
#import "MyFavorCollectionViewCell.h"
#import "ContactSellerViewController.h"


@interface MyFavoriteViewController ()

- (IBAction)backBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *myFavoriteCollection;

- (IBAction)heartBtn_tapped:(id)sender;
- (IBAction)shareBtn_tapped:(id)sender;
- (IBAction)contactSellerBtn_tapped:(id)sender;




@property (strong, nonatomic) NSMutableArray *myFavoriteArray;
@property (strong, nonatomic) AppDelegate *appdelegate;
@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    _uid = [userDefault valueForKey:@"kUid"];
    _userType = [userDefault valueForKey:@"kUserType"];
    
    _myFavoriteArray = [[NSMutableArray alloc] init];
    _appdelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [self fetchMyFavoriteListFromCoreData];
}

-(void)fetchMyFavoriteListFromCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:_appdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
        
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_sync(queue, ^{
        NSError *error;
        NSArray *fetchedArray = [_appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Property *property in fetchedArray) {
                if ([property.myUserId isEqualToString:_uid]) {
                    [_myFavoriteArray addObject:property];
                }
            }
            [self.myFavoriteCollection reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- CollectionView Delegate Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_myFavoriteArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier = @"myCollectionCell";
    MyFavorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndetifier forIndexPath:indexPath];
    Property *property = [_myFavoriteArray objectAtIndex:indexPath.row];
    
    cell.address1Lbl.text = property.address1;
    cell.address2Lbl.text = property.address2;
    cell.typeAndSizeLbl.text = [NSString stringWithFormat:@"%@, %@",property.type,property.size];
    NSString *category = property.category;
    if ([category isEqualToString:@"1"]) {
        cell.categoryLbl.text = @"For Rent";
        cell.priceLbl.text = [NSString stringWithFormat:@"$%@/mo",property.cost];
    }
    else {
        cell.categoryLbl.text = @"For Sale";
        cell.priceLbl.text = [NSString stringWithFormat:@"$%@",property.cost];
    }
    cell.descrip.text = property.descri;
    cell.heartBtn.tag = indexPath.row;
    cell.shareBtn.tag = indexPath.row;
    cell.contactSellerBtn.tag = indexPath.row;
    
    dispatch_queue_t queque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_sync(queque, ^{
        NSString *img = property.imagePath;
        NSString *str = @"";
        str = [img stringByReplacingOccurrencesOfString:@"\\"                                                withString:@"/"];
        NSString *string = [NSString stringWithFormat:@"http://%@",str];
        NSURL *imgUrl = [NSURL URLWithString:string];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imgView.image = [UIImage imageWithData:data];
            if (cell.imgView.image == nil) {
                cell.imgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
            }
        });
    });
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn_tapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)heartBtn_tapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Delete the propert from your favorite list?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Property *property = [_myFavoriteArray objectAtIndex:btn.tag];
        [_appdelegate.managedObjectContext deleteObject:property];
        NSError *deleteError;
        if (![_appdelegate.managedObjectContext save:&deleteError]) {
            NSLog(@"Delete property error: %@",[deleteError description]);
        }
        [_myFavoriteArray removeObjectAtIndex:btn.tag];
        [self.myFavoriteCollection reloadData];
    }];
    [controller addAction:cancelAction];
    [controller addAction:deleteAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)shareBtn_tapped:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    Property *property = [_myFavoriteArray objectAtIndex:btn.tag];
    
    NSString *address1 = property.address1;
    NSString *address2 = property.address2;
    NSString *typeAndSize = [NSString stringWithFormat:@"%@, %@",property.type,property.size];
    NSString *category = property.category;
    NSString *categoryType = @"";
    NSString *price = @"";
    if ([category isEqualToString:@"1"]) {
        categoryType = @"For Rent";
        price = [NSString stringWithFormat:@"$%@/mo",property.cost];
    }
    else {
        categoryType = @"For Sale";
        price = [NSString stringWithFormat:@"$%@",property.cost];
    }
    NSString *decrip = property.descri;
    
    NSArray *shared = @[[NSString stringWithFormat:@"Address: %@, %@",address1, address2],typeAndSize,categoryType,price,decrip];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:shared applicationActivities:nil];
    NSArray *excludeArr = @[UIActivityTypePrint, UIActivityTypeOpenInIBooks, UIActivityTypePostToWeibo];
    activity.excludedActivityTypes = excludeArr;
    [self presentViewController:activity animated:YES completion:nil];
    
}

- (IBAction)contactSellerBtn_tapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    ContactSellerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactSellerViewController"];
    Property *property = [_myFavoriteArray objectAtIndex:btn.tag];
    controller.sellerId = property.sellerUid;
    [self presentViewController:controller animated:YES completion:nil];
}
@end
