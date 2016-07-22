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

@interface MyFavoriteViewController ()

- (IBAction)backBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *myFavoriteCollection;

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
    
    NSString *img = property.imagePath;
    if (![img length]) {
        cell.imgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
    }
    else {
        NSString *str = @"";
        str = [img stringByReplacingOccurrencesOfString:@"\\"                                                withString:@"/"];
        NSString *string = [NSString stringWithFormat:@"http://%@",str];
        NSURL *imgUrl = [NSURL URLWithString:string];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        cell.imgView.image = [UIImage imageWithData:data];
    }

    
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
@end
