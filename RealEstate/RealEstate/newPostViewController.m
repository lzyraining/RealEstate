//
//  newPostViewController.m
//  RealEstate
//
//  Created by Shuting lang on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "newPostViewController.h"
#import "typePopoverViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface newPostViewController () <UIPopoverPresentationControllerDelegate>
{

    NSString *prpname;
    NSString *prp;
    NSString *prpcost;
    NSString *prpsize;
    NSString *prpdesc;
    int imgCount;
    NSMutableArray *imgDataArr;
    NSString *resp;
    NSURL *requestURL;
}
@property (nonatomic, strong) typePopoverViewController *popover;
@property (weak, nonatomic) IBOutlet UILabel *prpTypeLbl;
- (IBAction)backBtn_Tapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *prpNameTF;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn_Outlet;
@property (weak, nonatomic) IBOutlet UITextField *prpCostTF;
@property (weak, nonatomic) IBOutlet UITextField *prpSizeTF;
@property (weak, nonatomic) IBOutlet UITextView *prpDescTView;
- (IBAction)prpImageBtn_Tapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *prpImgBtn_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *imgChosenLbl;
- (IBAction)submitBtn_Tapped:(UIButton *)sender;
- (IBAction)prpCatBtn_Tapped:(UIButton *)sender;
@property(nonatomic, strong) UIImagePickerController *imgPickr;
@property (weak, nonatomic) IBOutlet UIImageView *prpImgView;
@property (weak, nonatomic) IBOutlet UILabel *unitLbl;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *sbmtBtn_Outlet;

@end

@implementation newPostViewController
@synthesize prpType,crtPrp,isEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.unitLbl.text = @"$";
    if (crtPrp) {
        self.prpNameTF.text = [crtPrp valueForKey:@"Property Name"];
        if ([[crtPrp valueForKey:@"Property Category"] intValue]==1) {
            self.sellBtn_Outlet.selected = YES;
            self.rentBtn_Outlet.selected = NO;
        }else{
            self.sellBtn_Outlet.selected = NO;
            self.rentBtn_Outlet.selected = YES;
            self.unitLbl.text = @"$/mo";
        }
        self.prpTypeLbl.text = [crtPrp valueForKey:@"Property Type"];
        self.prpCostTF.text = [crtPrp valueForKey:@"Property Cost"];
        self.prpSizeTF.text = [crtPrp valueForKey:@"Property Size"];
        self.prpDescTView.text = [crtPrp valueForKey:@"Property Desc"];
        NSString *crtImgStr = [crtPrp valueForKey:@"Property Image 1"];
        if ([crtImgStr isEqualToString:@""]) {
            self.prpImgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
        }else{
            NSURL *crtUrl = [NSURL URLWithString:crtImgStr];
            NSData *crtData = [NSData dataWithContentsOfURL:crtUrl];
            self.prpImgView.image = [UIImage imageWithData:crtData];
        }
    }
    [self getRealAddress];
    imgCount = 0;
    self.typeBtn_Outlet.layer.cornerRadius = 10.0;
    self.sbmtBtn_Outlet.layer.cornerRadius = 10.0;
    self.prpDescTView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.prpDescTView.layer.borderWidth = 1.0;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (prpType != nil) {
        self.prpTypeLbl.text = prpType;
        prpType = nil;
    }

}

-(void)chooseImg{
    
    _imgPickr = [[UIImagePickerController alloc]init];
    _imgPickr.allowsEditing = YES;
    _imgPickr.delegate = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openGalleryUsingPickerController];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma -mark image Picker Controller delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString * ,id> *)editingInfo
{
    self.prpImgView.image = image;
    self.imgChosenLbl.text = [NSString stringWithFormat:@"%d Image Selected", imgCount+1];
    imgCount = imgCount + 1;
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSData *imageData = UIImageJPEGRepresentation(_prpImgView.image, 1.0);
    //[imgDataArr addObject:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)openGalleryUsingPickerController{
    
    _imgPickr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imgPickr animated:YES completion:nil];
    
};


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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"popoverSegue"]) {
        self.popover = [segue destinationViewController];
        self.popover.popoverPresentationController.delegate = self;
        self.popover.protocol = self;
        
        if ([sender isKindOfClass:UIView.class]) {
            // Fetch the destination view controller
            UIViewController *destinationViewController = [segue destinationViewController];
            
            // If there is indeed a UIPopoverPresentationController involved
            if ([destinationViewController respondsToSelector:@selector(popoverPresentationController)]) {
                // Fetch the popover presentation controller
                UIPopoverPresentationController *popoverPresentationController =
                destinationViewController.popoverPresentationController;
                //popoverPresentationController.preferredContentSize = CGSizeMake(279.0, 180.0)
                // Set the correct sourceRect given the sender's bounds
                popoverPresentationController.sourceRect = CGRectMake(40.0, 683.0, 200.0, 180.0);
            }
        }
        
    }

}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
    
}

- (IBAction)backBtn_Tapped:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)prpImageBtn_Tapped:(UIButton *)sender {
    
    if (imgCount >= 3) {
        self.prpImgBtn_Outlet.enabled = NO;
    }else{
        [self chooseImg];
    }
}
- (IBAction)submitBtn_Tapped:(UIButton *)sender {
    
    [self getPostInfo];
    
}

-(void)setPrpType:(NSString *)type{

    prpType = type;
    self.prpTypeLbl.text = prpType;

};


-(void)getPostInfo{
    
    NSURLRequest *request = [self getNSURLRequest];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            resp = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",resp);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([resp containsString:@"true"]) {
                    
                    if (isEdit == YES) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congrats" message:@"This property infomation has changed!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            NSLog(@"EditOOOOOOKKKKKKKK");
                            
                            
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];

                    }else{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congrats" message:@"This property has added to your list!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            NSLog(@"OOOOOOKKKKKKKK");
                            
                            
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Cant submit diet due to unknown error" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
            });
            
        }else{
            NSLog(@"%@",error);
        }
    }]resume];

    
}

-(NSURLRequest *)getNSURLRequest{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self getRealAddress];
        
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:self.prpNameTF.text forKey:@"propertyname"];
    [_params setObject:self.prpTypeLbl.text forKey:@"propertytype"];
    [_params setObject:[defaults objectForKey:@"prpCat"] forKey:@"propertycat"];
    [_params setObject:[defaults objectForKey:@"addr1"] forKey:@"propertyaddress1"];
    [_params setObject:[NSString stringWithFormat:@"addr2"] forKey:@"propertyaddress2"];
    [_params setObject:self.prpCostTF.text forKey:@"propertycost"];
    [_params setObject:self.prpSizeTF.text forKey:@"propertysize"];
    [_params setObject:[defaults objectForKey:@"zipcode"] forKey:@"propertyzip"];
    [_params setObject:[defaults objectForKey:@"prplat"] forKey:@"propertylat"];
    [_params setObject:[defaults objectForKey:@"prplon"] forKey:@"propertylong"];
    [_params setObject:[defaults objectForKey:@"prpDesc"] forKey:@"propertydesc"];
    [_params setObject:@"yes" forKey:@"propertystatus"];
    [_params setObject:[defaults objectForKey:@"kUid"] forKey:@"userid"];

    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
//    NSArray *fileParamConst = @[@"Property Image 1",@"Property Image 2",@"Property Image 3"];
    NSString* FileParamConstant = @"propertyimg1";
    
    if (isEdit == YES) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/register.php?property&edit&pptyid=%@",[crtPrp valueForKey:@"Property Id"]]];
    }else{
        requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/register.php?property&add"];
    }
    
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
    
    // add image data
    //for (int i=0; i<imgDataArr.count; i++) {
    //    if (imgDataArr) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"prpimg1.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *imageData = UIImageJPEGRepresentation(_prpImgView.image, 1.0);
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
      //  }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

   // }
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    return request;
    
}



-(void)getRealAddress{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[defaults valueForKey:@"prplat"] floatValue] longitude:[[defaults valueForKey:@"prplon"] floatValue]];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
                  
         [defaults setObject:[NSString stringWithFormat:@"%@",placemark.name] forKey:@"addr1"];
         [defaults setObject:[NSString stringWithFormat:@"%@,%@,",placemark.locality,placemark.country] forKey:@"addr2"];
         [defaults setObject:[NSString stringWithFormat:@"%@",placemark.postalCode] forKey:@"zipcode"];
         
     }];

}


- (IBAction)prpCatBtn_Tapped:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (sender.tag == 101) {
        _rentBtn_Outlet.selected = NO;
        self.unitLbl.text = @"$";
        _sellBtn_Outlet.selected = YES;
    }else{
        _rentBtn_Outlet.selected = YES;
        _sellBtn_Outlet.selected = NO;
        self.unitLbl.text = @"$/mo";
    }
    if (_rentBtn_Outlet.selected == YES) {
        [defaults setValue:@"2" forKey:@"prpCat"];
    }else{
        [defaults setValue:@"1" forKey:@"prpCat"];
    }
    
}
@end
