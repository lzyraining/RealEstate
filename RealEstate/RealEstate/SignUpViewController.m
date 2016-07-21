//
//  SignUpViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SignUpViewController (){

    NSString *dateStr;

}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *pswdTF;
@property (weak, nonatomic) IBOutlet UITextField *rePswdTF;
@property (weak, nonatomic) IBOutlet UITextField *dobTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *addr1TF;
@property (weak, nonatomic) IBOutlet UITextField *addr2TF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn_outlet;
- (IBAction)submitBtn_Tapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *dobSubView;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickrToolBar;
- (IBAction)barDoneBtn_Tapped:(UIBarButtonItem *)sender;
- (IBAction)barCancelBtn_Tapped:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickr_outlet;
- (IBAction)datePickr_Tapped:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UILabel *userNameAlertLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailAlertLbl;
@property (weak, nonatomic) IBOutlet UILabel *pswdAlertLbl;
@property (weak, nonatomic) IBOutlet UILabel *rePswdAlertLbl;

@end

@implementation SignUpViewController
@synthesize userType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dobSubView setHidden:YES];
    [_userNameAlertLbl setHidden:YES];
    [_emailAlertLbl setHidden:YES];
    [_pswdAlertLbl setHidden:YES];
    [_rePswdAlertLbl setHidden:YES];
    [_userNameTF becomeFirstResponder];
}

#pragma -mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

//    if (textField == _addr1TF || textField == _addr2TF || textField == _mobileTF) {
//        [self animatedTextField:textField UP:NO];
//    }
    CGRect frame = self.view.frame;
    frame.origin.x = 0; // new x coordinate
    frame.origin.y = 0; // new y coordinate
    self.view.frame = frame;
    
    [textField resignFirstResponder];
    return YES;
    
};              // called when 'return' key pressed. return NO to ignore.

- (void)textFieldDidEndEditing:(UITextField *)textField{

    CGRect frame = self.view.frame;
    frame.origin.x = 0; // new x coordinate
    frame.origin.y = 0; // new y coordinate
    self.view.frame = frame;
    
    [textField resignFirstResponder];

};             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField == _addr1TF || textField == _addr2TF || textField == _mobileTF) {
        [self animatedTextField:textField UP:YES withDIS:50];
    }else if (textField == _addr2TF){
        [self animatedTextField:textField UP:YES withDIS:60];
    }else if (textField == _mobileTF){
        [self animatedTextField:textField UP:YES withDIS:40];
    }
    if (textField == _dobTF) {
        [self.dobSubView setHidden:NO];
        [textField resignFirstResponder];
    }else{
        [self.dobSubView setHidden:YES];
    }
    
};           // became first responder

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


- (IBAction)submitBtn_Tapped:(UIButton *)sender {
    
    if ([self isPrimaryKeyValid]) {
        [self callSignUpAPI];
    }
    
}
- (IBAction)barDoneBtn_Tapped:(UIBarButtonItem *)sender {
    
    if ([dateStr length]) {
        self.dobTF.text = dateStr;
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        
        NSDate *date = [NSDate date];
        NSString *dateString = [dateFormatter stringFromDate:date];
        dateStr = dateString;
        self.dobTF.text = dateStr;
    }
    
    [_dobTF resignFirstResponder];
    [self.dobSubView setHidden:YES];
    
}

- (IBAction)barCancelBtn_Tapped:(UIBarButtonItem *)sender {
    
    [self.dobSubView setHidden:YES];
    [_dobTF resignFirstResponder];
    
}
- (IBAction)datePickr_Tapped:(UIDatePicker *)sender {
    
    NSDateFormatter *datefomat = [[NSDateFormatter alloc] init];
    [datefomat setDateFormat:@"MM/DD/YYYY"];
    
    NSString *formattedDate = [datefomat stringFromDate:self.datePickr_outlet.date];
    dateStr = formattedDate;
    
}

-(BOOL)isPrimaryKeyValid{

    if (![_userNameTF.text length]) {
        _userNameTF.layer.borderColor = [[UIColor redColor] CGColor];
        _userNameTF.layer.borderWidth = 1.0f;
        [_userNameAlertLbl setHidden:NO];
        [_userNameTF becomeFirstResponder];
        return NO;
    }

    if (![_emailTF.text length]) {
        _emailTF.layer.borderColor = [[UIColor redColor] CGColor];
        _emailTF.layer.borderWidth = 1.0f;
        [_emailAlertLbl setHidden:NO];
        if ([_userNameTF.text length]) {
            UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            
            _userNameTF.layer.borderColor = borderColor.CGColor;
            _userNameTF.layer.borderWidth = 1.0;
            _userNameTF.layer.cornerRadius = 5.0;
            [_userNameAlertLbl setHidden:YES];
            [_emailTF becomeFirstResponder];
        }
        return NO;
    }
    
    if (![_pswdTF.text length]) {
        _pswdTF.layer.borderColor = [[UIColor redColor] CGColor];
        _pswdTF.layer.borderWidth = 1.0f;
        [_pswdAlertLbl setHidden:NO];
        if ([_userNameTF.text length] && [_emailTF.text length]) {
            UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            
            _userNameTF.layer.borderColor = borderColor.CGColor;
            _userNameTF.layer.borderWidth = 1.0;
            _userNameTF.layer.cornerRadius = 5.0;
            [_userNameAlertLbl setHidden:YES];
            
            _emailTF.layer.borderColor = borderColor.CGColor;
            _emailTF.layer.borderWidth = 1.0;
            _emailTF.layer.cornerRadius = 5.0;
            [_emailAlertLbl setHidden:YES];
            [_pswdTF becomeFirstResponder];
        }
        return NO;
    }
    
    if (![_rePswdTF.text length]) {
        _rePswdAlertLbl.text = @"This is required field.";
        _rePswdTF.layer.borderColor = [[UIColor redColor] CGColor];
        _rePswdTF.layer.borderWidth = 1.0f;
        [_rePswdAlertLbl setHidden:NO];
        if ([_userNameTF.text length] && [_emailTF.text length] && [_pswdTF.text length]) {
            UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            
            _userNameTF.layer.borderColor = borderColor.CGColor;
            _userNameTF.layer.borderWidth = 1.0;
            _userNameTF.layer.cornerRadius = 5.0;
            [_userNameAlertLbl setHidden:YES];
            _emailTF.layer.borderColor = borderColor.CGColor;
            _emailTF.layer.borderWidth = 1.0;
            _emailTF.layer.cornerRadius = 5.0;
            [_emailAlertLbl setHidden:YES];
            _pswdTF.layer.borderColor = borderColor.CGColor;
            _pswdTF.layer.borderWidth = 1.0;
            _pswdTF.layer.cornerRadius = 5.0;
            [_pswdAlertLbl setHidden:YES];
            [_rePswdTF becomeFirstResponder];
        }
        return NO;
    }else if (![_rePswdTF.text isEqualToString:_pswdTF.text]){
        
        _rePswdAlertLbl.text = @"Password should be same.";
        _rePswdTF.layer.borderColor = [[UIColor redColor] CGColor];
        _rePswdTF.layer.borderWidth = 1.0f;
        [_rePswdAlertLbl setHidden:NO];
        if ([_userNameTF.text length] && [_emailTF.text length] && [_pswdTF.text length]) {
            UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            
            _userNameTF.layer.borderColor = borderColor.CGColor;
            _userNameTF.layer.borderWidth = 1.0;
            _userNameTF.layer.cornerRadius = 5.0;
            [_userNameAlertLbl setHidden:YES];
            _emailTF.layer.borderColor = borderColor.CGColor;
            _emailTF.layer.borderWidth = 1.0;
            _emailTF.layer.cornerRadius = 5.0;
            [_emailAlertLbl setHidden:YES];
            _pswdTF.layer.borderColor = borderColor.CGColor;
            _pswdTF.layer.borderWidth = 1.0;
            _pswdTF.layer.cornerRadius = 5.0;
            [_pswdAlertLbl setHidden:YES];
            [_rePswdTF becomeFirstResponder];
        }
        return NO;
    }
    return YES;

}

#pragma post methods

-(void)callSignUpAPI{
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([str isEqualToString:@"bool(true)\n"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congrats!" message:@"New Account Created!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Sign up failed with unknown error" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
            
        }
    }]resume];
}

-(NSURLRequest *)getNSURLRequest{
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",_userNameTF.text] forKey:@"username"];
    [_params setObject:[NSString stringWithFormat:@"%@", _emailTF.text] forKey:@"email"];
    [_params setObject:[NSString stringWithFormat:@"%@",_pswdTF.text] forKey:@"password"];
    [_params setObject:[NSString stringWithFormat:@"%@",_dobTF.text] forKey:@"dob"];
    [_params setObject:[NSString stringWithFormat:@"%@",_mobileTF.text] forKey:@"mobile"];
    [_params setObject:[NSString stringWithFormat:@"%@",_addr1TF.text] forKey:@"addr1"];
    [_params setObject:[NSString stringWithFormat:@"%@",_addr2TF.text] forKey:@"addr2"];
    [_params setObject:[NSString stringWithFormat:@"%@",userType] forKey:@"userType"];
    [_params setObject:[NSString stringWithFormat:@"Yes"] forKey:@"userStatus"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://rjtmobile.com/realestate/register.php?signup"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
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

#pragma -mark moveup method

-(void)animatedTextField:(UITextField*)textField UP:(BOOL)up withDIS:(int)distance
{
    const int movementDistance = distance;
    const float movementDuration = 0.3f;
    int movement = (up ?-movementDistance:movementDistance);
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



@end
