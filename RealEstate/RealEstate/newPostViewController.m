//
//  newPostViewController.m
//  RealEstate
//
//  Created by Shuting lang on 7/21/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "newPostViewController.h"
#import "typePopoverViewController.h"

@interface newPostViewController () <UIPopoverPresentationControllerDelegate>
{

    NSString *prpname;
    NSString *prp;
    NSString *prpcost;
    NSString *prpsize;
    NSString *prpdesc;
    NSMutableArray *imgArr;
    
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
@property (weak, nonatomic) IBOutlet UILabel *imgChosenLbl;
- (IBAction)submitBtn_Tapped:(UIButton *)sender;
- (IBAction)prpCatBtn_Tapped:(UIButton *)sender;
@property(nonatomic, strong) UIImagePickerController *imgPickr;
@property (weak, nonatomic) IBOutlet UIImageView *prpImgView;

@end

@implementation newPostViewController
@synthesize prpType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    self.imgChosenLbl.text = [NSString stringWithFormat:@"%lu Image Selected", (unsigned long)imgArr.count];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self chooseImg];
    
}
- (IBAction)submitBtn_Tapped:(UIButton *)sender {
    
//    [self getPostInfo];
    
}

//-(void)getPostInfo{
//    
//   /* NSURLRequest *request = [self getNSURLRequest];
//    
//    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if(!error){
//            resp = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            //NSLog(@"%@",resp);
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                if ([resp containsString:@"true"]) {
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congrats" message:@"This food has added to your food list!" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                        //*************  NSBatchDeleteRequest method  *********************
//                        //                        NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
//                        //                        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MyFoodDataModal"];
//                        //                        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
//                        //
//                        //                        NSError *deleteError = nil;
//                        //                        [myPersistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
//                        NSLog(@"OOOOOOKKKKKKKK");
//                        
//                        
//                    }];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:nil];
//                    
//                }else{
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Cant submit diet due to unknown error" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:nil];
//                    
//                }
//                
//            });
//            
//        }else{
//            NSLog(@"%@",error);
//        }
//    }]resume];
//    */
//    
//}
//
//-(NSURLRequest *)getNSURLRequest{
//    /*
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:_prpNameTF.text forKey:@"prpName"];
//    [defaults setValue:_prpSizeTF.text forKey:@"prpCost"];
//    [defaults setValue:_prpCostTF.text forKey:@"prpSize"];
//    [defaults setValue:_prpDescTView.text forKey:@"prpDesc"];
//    [defaults setValue:prpType forKey:@"prpType"];
//
//        
//    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
//    [_params setObject:prpname forKey:@"propertyname"];
//    [_params setObject:prpType forKey:@"propertytype"];
//    [_params setObject: forKey:@"foodcalories"];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [_params setObject:[defaults valueForKey:@"userID"] forKey:@"userid"];
//    [_params setObject:[NSString stringWithFormat:@"Yes"] forKey:@"foodstatus"];
//    
//    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
//    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
//    
//    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
//    NSString* FileParamConstant = @"foodimage1";
//    
//    NSURL* requestURL = [NSURL URLWithString:@"http://rjtmobile.com/foodplan/register.php?food"];
//    
//    // create request
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:30];
//    [request setHTTPMethod:@"POST"];
//    
//    // set Content-Type in HTTP header
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    // post body
//    NSMutableData *body = [NSMutableData data];
//    
//    // add params (all params are strings)
//    for (NSString *param in _params) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    // add image data
//    NSData *imageData = UIImageJPEGRepresentation(_img1View.image, 1.0);
//    if (imageData) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", FileParamConstant,_foodNameTF.text] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:imageData];
//        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // setting the body of the post to the reqeust
//    [request setHTTPBody:body];
//    
//    // set the content-length
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    // set URL
//    [request setURL:requestURL];
//    return request;
//    */
//}


- (IBAction)prpCatBtn_Tapped:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (sender.tag) {
        case 101:
            _rentBtn_Outlet.selected = NO;
            [defaults setValue:@"1" forKey:@"prpCat"];
            break;
        case 102:
            _sellBtn_Outlet.selected = NO;
            [defaults setValue:@"2" forKey:@"prpCat"];
            break;
            
        default:
            break;
    }
    
}
@end
