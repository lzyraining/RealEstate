//
//  MyFavoriteViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "AppDelegate.h"

@interface MyFavoriteViewController ()

- (IBAction)backBtn_tapped:(id)sender;

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
        for (Property *property in fetchedArray) {
            if ([property.myUserId isEqualToString:_uid]) {
                [_myFavoriteArray addObject:property];
            }
        }
        NSLog(@"%@",_myFavoriteArray);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
