//
//  HomeViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "HomeViewController.h"
#import "MyPostViewController.h"
#import "MyMapView.h"
#import "MyTableView.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *myPostBtn;
- (IBAction)myPostBtn_tapped:(id)sender;
- (IBAction)signOutBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *diplayLbl;

@property (strong, nonatomic) IBOutlet UIView *presentView;
@property (strong, nonatomic) MyMapView *myMapView;
@property (strong, nonatomic) MyTableView *myTableView;

- (IBAction)displayBtn_tapped:(id)sender;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    _uid = [userDefault valueForKey:@"kUid"];
    _userType = [userDefault valueForKey:@"kUserType"];
    if ([_userType isEqualToString:@"buyer"]) {
        [_myPostBtn setHidden:YES];
    }
    self.myMapView = [[[NSBundle mainBundle] loadNibNamed:@"MyMapView" owner:self options:nil] objectAtIndex:0];
    self.myTableView = [[[NSBundle mainBundle] loadNibNamed:@"MyTableView" owner:self options:nil] objectAtIndex:0];
    self.myMapView.frame = CGRectMake(0, 0, self.presentView.frame.size.width, self.presentView.frame.size.height);
    self.myTableView.frame = CGRectMake(0, 0, self.presentView.frame.size.width, self.presentView.frame.size.height);
    [self.presentView addSubview:_myMapView];
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

- (IBAction)myPostBtn_tapped:(id)sender {
    MyPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)signOutBtn_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)displayBtn_tapped:(id)sender {
    if ([_diplayLbl.text isEqualToString:@"List"]) {
        _diplayLbl.text = @"Map";
        [UIView transitionWithView:self.presentView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self.myMapView removeFromSuperview];
                            [self.presentView addSubview:self.myTableView];
                            _myTableView.myLbl.text = @"Hello";
                        } completion:nil];

    }
    else {
        _diplayLbl.text = @"List";
        [UIView transitionFromView:_myTableView
                            toView:_myMapView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
        
    }
}
@end
