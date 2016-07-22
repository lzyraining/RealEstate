//
//  ViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "HomeViewController.h"

@interface ViewController ()
- (IBAction)signupBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberSwitch;
- (IBAction)signinBtn_tapped:(id)sender;

- (IBAction)userTypeBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sellerBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyerBtn;

@property (weak, nonatomic) IBOutlet UIView *loginSubView;
@property (weak, nonatomic) IBOutlet UIImageView *loginBgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    if ([userDefault valueForKey:@"kRemember"] != nil) {
        NSString *remember = [userDefault valueForKey:@"kRemember"];
        NSString *userType = [userDefault valueForKey:@"kUserType"];
        _emailTextField.text = [userDefault valueForKey:@"kEmail"];
        _passwordTextField.text = [userDefault valueForKey:@"kPassword"];
        if ([remember isEqualToString:@"YES"]) {
            _rememberSwitch.on = YES;
        }
        else {
            _rememberSwitch.on = NO;
        }
        if ([userType isEqualToString:@"seller"]) {
            _sellerBtn.selected = YES;
            _buyerBtn.selected = NO;
        }
        else {
            _sellerBtn.selected = NO;
            _buyerBtn.selected = YES;
        }
    }
    [self setLoginSubViewUIcomponent];
    [self setupAnimation];
}

-(void)setLoginSubViewUIcomponent {
    
    CALayer *emailBorder = [CALayer layer];
    emailBorder.frame = CGRectMake(0.0f, self.emailTextField.frame.size.height - 1, self.emailTextField.frame.size.width, 1.0f);
    emailBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.emailTextField.layer addSublayer:emailBorder];
    
    CALayer *passwordBorder = [CALayer layer];
    passwordBorder.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
    passwordBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.passwordTextField.layer addSublayer:passwordBorder];
    
}

-(void)setupAnimation {
    
    [_loginBgView setFrame:CGRectMake(-80, -80, 455, 520)];
    [UIView beginAnimations:@"animateBgImageView" context:nil];
    [UIView setAnimationDuration:1.2];
    [_loginBgView setFrame:CGRectMake(0, 0, 375, 440)];
    [self.view addSubview:_loginBgView];
    [UIView commitAnimations];
    
    [_logoImgView setFrame:CGRectMake(55, 667, 284, 59)];
    [UIView beginAnimations:@"animateLogoImgView" context:nil];
    [UIView setAnimationDuration:0.6];
    [_logoImgView setFrame:CGRectMake(55, 28, 284, 59)];
    [self.view addSubview:_logoImgView];
    [UIView commitAnimations];
    
    [_loginSubView setFrame:CGRectMake(42, 667, 305, 270)];
    [UIView beginAnimations:@"animateLoginSubView" context:nil];
    [UIView setAnimationDuration:0.8];
    [_loginSubView setFrame:CGRectMake(42, 351, 305, 270)];
    [self.view addSubview:_loginSubView];
    [UIView commitAnimations];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupBtn_tapped:(id)sender {
    SignUpViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (IBAction)signinBtn_tapped:(id)sender {
    if (!_sellerBtn.selected && !_buyerBtn.selected) {
        [self showAlertForLogIn:@"Please select user type"];
    }
    else {
        [self callLogInApi];
    }
}


-(void)showAlertForLogIn: (NSString*)msg {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction: action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)userTypeBtn_tapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 0) {
        _sellerBtn.selected = !_sellerBtn.selected;
        _buyerBtn.selected = NO;
    }
    else {
        _sellerBtn.selected = NO;
        _buyerBtn.selected = !_buyerBtn.selected;
    }
}

-(void)callLogInApi {
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getLogInNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
 
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (json == nil || ![json count]) {
                    [self showAlertForLogIn:@"Email or password is not valid"];
                }
                else {
                    NSDictionary *userInfoDict = json[0];
                    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
                    if (_rememberSwitch.on) {
                        [userDefault setObject:_emailTextField.text forKey:@"kEmail"];
                        [userDefault setObject:_passwordTextField.text forKey:@"kPassword"];
                        [userDefault setObject:@"YES" forKey:@"kRemember"];
                    }
                    else {
                        [userDefault setObject:@"" forKey:@"kEmail"];
                        [userDefault setObject:@"" forKey:@"kPassword"];
                        [userDefault setObject:@"NO" forKey:@"kRemember"];
                    }
                    [userDefault setObject:[userInfoDict valueForKey:@"User Id"] forKey:@"kUid"];
                    [userDefault setObject:[userInfoDict valueForKey:@"User Type"] forKey:@"kUserType"];
                    
                    HomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            });
        }
    }] resume];
}

-(NSURLRequest *)getLogInNSURLRequest{
    
    NSString *userType = @"";
    if(_sellerBtn.selected) {
        userType = @"seller";
    }
    else {
        userType = @"buyer";
    }
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",_emailTextField.text] forKey:@"email"];
    [_params setObject:[NSString stringWithFormat:@"%@",_passwordTextField.text] forKey:@"password"];
    [_params setObject:[NSString stringWithFormat:@"%@",userType] forKey:@"usertype"];

    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ckwehbqgZCaKO6jy";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://rjtmobile.com/realestate/register.php?login"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:180];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    return request;
}


@end
