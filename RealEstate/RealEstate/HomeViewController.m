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
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

- (IBAction)displayBtn_tapped:(id)sender;


@property (strong, nonatomic) NSArray *propertListDataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _propertListDataArray = [[NSArray alloc] init];
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    _uid = [userDefault valueForKey:@"kUid"];
    _userType = [userDefault valueForKey:@"kUserType"];
    if ([_userType isEqualToString:@"buyer"]) {
        [_myPostBtn setHidden:YES];
    }
    
    self.myMapView = [[[NSBundle mainBundle] loadNibNamed:@"MyMapView" owner:self options:nil] objectAtIndex:0];
    self.myTableView = [[[NSBundle mainBundle] loadNibNamed:@"MyTableView" owner:self options:nil] objectAtIndex:0];
    [self.myTableView.tbView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myTableCell"];
    
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
                            [self callPropertySearchApi];
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

#pragma mark- TableView Delegate Controller
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_propertListDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myTableCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [_propertListDataArray objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = [dict valueForKey:@"Property Name"];
    cell.address1Lbl.text = [dict valueForKey:@"Property Address1"];
    cell.address2Lbl.text = [dict valueForKey:@"Property Address2"];
    
    NSString *img = [dict valueForKey:@"Property Image 1"];
    if (![img length]) {
        cell.imgView.image = [UIImage imageNamed:@"photo_na.jpg"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

#pragma mark- TextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self callPropertySearchApi];
    [textField resignFirstResponder];
    return YES;
}// called when 'return' key pressed. return NO to ignore.

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_zipCodeTextField resignFirstResponder];
}

-(void)callPropertySearchApi {
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getPropertySearchNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            dispatch_sync(dispatch_get_main_queue(), ^{
                _propertListDataArray = json;
                [self.myTableView.tbView reloadData];
            });
        }
    }] resume];
}

-(NSURLRequest *)getPropertySearchNSURLRequest{
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?psearch&pname=&pptype=&ploc=3433433&pcatid="];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:180];
    [request setHTTPMethod:@"GET"];
    
    // set URL
    [request setURL:requestURL];
    return request;
}

@end
