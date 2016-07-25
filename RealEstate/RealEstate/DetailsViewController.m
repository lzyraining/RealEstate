//
//  DetailsViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/24/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "DetailsViewController.h"
#import "ContactSellerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *address2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *typeAndSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UITextView *descripText;


@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)backBtn_tapped:(id)sender;

- (IBAction)contactSellerBtn_tapped:(id)sender;

@property (strong, nonatomic) NSMutableArray *myFavoriteArray;

@end

@implementation DetailsViewController

@synthesize propertyId = _propertyId;
@synthesize sellerUid = _sellerUid;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    _uid = [userDefault valueForKey:@"kUid"];
    _userType = [userDefault valueForKey:@"kUserType"];
    
    // Do any additional setup after loading the view.
    _myFavoriteArray = [[NSMutableArray alloc] init];
    
    [self callPropertySearchApi];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callPropertySearchApi {
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getPropertySearchNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            dispatch_sync(dispatch_get_main_queue(), ^{
                for (NSDictionary *dict in json) {
                    if ([_propertyId isEqualToString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"Property Id"]]]) {
                        
                        _address1Lbl.text = [dict valueForKey:@"Property Address1"];
                        _address2Lbl.text = [dict valueForKey:@"Property Address2"];
                        _typeAndSizeLbl.text = [NSString stringWithFormat:@"%@, %@",[dict valueForKey:@"Property Type"],[dict valueForKey:@"Property Size"]];
                        NSString *category = [dict valueForKey:@"Property Category"];
                        if ([category isEqualToString:@"1"]) {
                            _categoryLbl.text = @"For Rent";
                            _priceLbl.text = [NSString stringWithFormat:@"$%@/mo",[dict valueForKey:@"Property Cost"]];
                        }
                        else {
                            _categoryLbl.text = @"For Sale";
                            _priceLbl.text = [NSString stringWithFormat:@"$%@",[dict valueForKey:@"Property Cost"]];
                        }
                        _descripText.text = [dict valueForKey:@"Property Desc"];
                        _titleLbl.text = [dict valueForKey:@"Property Name"];
                        
                        _sellerUid = [dict valueForKey:@"User Id"];

                        
                        dispatch_queue_t queque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                        dispatch_sync(queque, ^{
                            NSString *img = [dict valueForKey:@"Property Image 1"];
                            NSString *str = @"";
                            str = [img stringByReplacingOccurrencesOfString:@"\\"                                                withString:@"/"];
                            NSString *string = [NSString stringWithFormat:@"http://%@",str];
                            NSURL *imgUrl = [NSURL URLWithString:string];
                            NSData *data = [NSData dataWithContentsOfURL:imgUrl];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _imgView.image = [UIImage imageWithData:data];
                                if (_imgView.image == nil) {
                                    _imgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
                                }
                            });
                        });
                    }
                }
            });
        }
    }] resume];
}

-(NSURLRequest *)getPropertySearchNSURLRequest{
    
    NSURL *requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?all"];
    
    NSLog(@"%@",requestURL);
    // the server url to which the image (or the media) is uploaded. Use your server url here
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)contactSellerBtn_tapped:(id)sender {
    ContactSellerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactSellerViewController"];
    controller.sellerId = _sellerUid;
    NSLog(@"%@",_sellerUid);
    [self presentViewController:controller animated:YES completion:nil];
}

@end
