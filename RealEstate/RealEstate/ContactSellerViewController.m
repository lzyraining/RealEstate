//
//  ContactSellerViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/23/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "ContactSellerViewController.h"

@interface ContactSellerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)contactBtn_tapped:(id)sender;
- (IBAction)backBtn_tapped:(id)sender;

@end

@implementation ContactSellerViewController

@synthesize sellerId = _sellerId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)contactBtn_tapped:(id)sender {
    [self contactSellerApi];
}

- (IBAction)backBtn_tapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)contactSellerApi {
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getSellerInfoNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",json);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Congras" message:@"We have send your message to the seller" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [controller addAction:action];
                [self presentViewController:controller animated:YES completion:nil];
            });
        }
    }] resume];
}

-(NSURLRequest *)getSellerInfoNSURLRequest{
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/realestate/register.php?userid=%@",_sellerId]];
    
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
