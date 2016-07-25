//
//  HomeViewController.m
//  RealEstate
//
//  Created by Zhuoyu Li on 7/20/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "HomeViewController.h"
#import "MyPostViewController.h"
#import "MyTableView.h"
#import "MyFavoriteViewController.h"
#import "AppDelegate.h"
#import "FilterViewController.h"
#import "filterObject.h"
#import "DetailsViewController.h"

@interface HomeViewController () <UIPopoverPresentationControllerDelegate, filterObjectProtocol>

@property (weak, nonatomic) IBOutlet UIButton *myPostBtn;
- (IBAction)myPostBtn_tapped:(id)sender;
- (IBAction)signOutBtn_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *displayBtn;

@property (strong, nonatomic) IBOutlet UIView *presentView;
@property (strong, nonatomic) MyMapView *myMapView;
@property (strong, nonatomic) MyTableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

- (IBAction)displayBtn_tapped:(id)sender;

- (IBAction)myFavoriteBtn_tapped:(id)sender;

- (IBAction)getMyLocationBtn_tapped:(id)sender;

@property (strong, nonatomic) NSArray *propertListDataArray;
@property (strong, nonatomic) NSMutableArray *propertyListPresentArray;
@property (strong, nonatomic) NSMutableArray *myFavoriteArray;

@property (strong, nonatomic) AppDelegate *appdelegate;

@property(strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) FilterViewController *filterPopover;

@property (strong, nonatomic) filterObject *fObject;

@property (strong, nonatomic) NSMutableArray *annotationArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _propertListDataArray = [[NSArray alloc] init];
    _propertyListPresentArray = [[NSMutableArray alloc] init];
    _myFavoriteArray = [[NSMutableArray alloc] init];

    _appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _fObject = [[filterObject alloc] init];
    
    _annotationArr = [[NSMutableArray alloc] init];
    
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
    
    //Configuer map
    [self.myMapView.mpView setShowsUserLocation:YES];
    [self.myMapView.mpView setZoomEnabled:YES];
    [self.myMapView.mpView setMapType:MKMapTypeStandard];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self callPropertySearchApi];
    [self fetchMyFavoriteListFromCoreData];
    [self.myTableView.tbView reloadData];
    
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

- (IBAction)myPostBtn_tapped:(id)sender {
    MyPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)signOutBtn_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)displayBtn_tapped:(id)sender {
    _displayBtn.selected = !_displayBtn.selected;
    if (_displayBtn.selected) {
        [UIView transitionWithView:self.presentView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self.myMapView removeFromSuperview];
                            [self.presentView addSubview:self.myTableView];
                        } completion:^(BOOL finished) {
                            [self.myTableView.tbView reloadData];
                        }];

    }
    else {
        [UIView transitionWithView:self.presentView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.myTableView removeFromSuperview];
                            [self.presentView addSubview:self.myMapView];
                        } completion:^(BOOL finished) {
                            [self showPropertyInMap];
                        }];
        
    }
}

- (IBAction)myFavoriteBtn_tapped:(id)sender {
    MyFavoriteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFavoriteViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)getMyLocationBtn_tapped:(id)sender {
    _zipCodeTextField.text = @"";
    [_locationManager startUpdatingLocation];
    [self callPropertySearchApi];
}


#pragma mark- PopOver View Method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"filterPopover"]) {
        self.filterPopover = [segue destinationViewController];
        self.filterPopover.popoverPresentationController.delegate = self;
        self.filterPopover.fObject = _fObject;
        self.filterPopover.delegate = self;
        
        if ([sender isKindOfClass:UIView.class]) {
            // Fetch the destination view controller
            UIViewController *destinationViewController = [segue destinationViewController];
        
            // If there is indeed a UIPopoverPresentationController involved
            if ([destinationViewController respondsToSelector:@selector(popoverPresentationController)]) {
                // Fetch the popover presentation controller
                UIPopoverPresentationController *popoverPresentationController =
                destinationViewController.popoverPresentationController;
                
                // Set the correct sourceRect given the sender's bounds
                popoverPresentationController.sourceRect = ((UIView *)sender).bounds;
            }
        }
        
    }
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

-(void)submitFilterContidiotn {
    [self callPropertySearchApi];
    if(self.myMapView) {
        [self showPropertyInMap];
    }
}


#pragma mark- MapView Delegate Method


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0) {
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        [_locationManager stopUpdatingLocation];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 5000, 5000);
                [self.myMapView.mpView setRegion:region];
            }
        }];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MKMapItem";
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.myMapView.mpView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"marker"];//here we use a nice image instead of the default pins
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    NSRange coma = [view.annotation.subtitle rangeOfString:@":"];
    NSString *string = [view.annotation.subtitle substringFromIndex:3];
    string = [string substringToIndex:coma.location-3];
    
    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    controller.propertyId = string;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)reverseGeoCoder:(NSString*) zipcode {
    CLGeocoder *zipGeocoder = [[CLGeocoder alloc] init];
    [zipGeocoder geocodeAddressString:zipcode completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if (placemarks && [placemarks count]>0) {
                CLPlacemark *place = [placemarks lastObject];
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:place];
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 5000, 5000);
//                region.center = placemark.location.coordinate;
//                region.span.latitudeDelta/=100.0;
//                region.span.longitudeDelta/=100.0;
                
                [self.myMapView.mpView setRegion:region animated:YES];
            }
        }
        else {
            NSLog(@"Address error: %@", [error description]);
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter valid address" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
}


-(void)reverseAddressGeocoder: (NSString*)address andInfo: (NSDictionary*) dict{

    _annotationArr = [[NSMutableArray alloc] init];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if (placemarks && [placemarks count]>0) {
                CLPlacemark *place = [placemarks lastObject];
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:place];
                
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = placemark.coordinate;
                point.title = [dict valueForKey:@"Property Name"];
                point.subtitle = [NSString stringWithFormat:@"Id %@: Cost %@",[dict valueForKey:@"Property Id"],[dict valueForKey:@"Property Cost"]];
    
                [_annotationArr addObject:point];
                
                [self.myMapView.mpView addAnnotation:point];
            }
        }
        else {
            NSLog(@"Error: %@",[error description]);
        }
    }];
}

-(void)showPropertyInMap {
    
    if ([_annotationArr count]) {
        [self.myMapView.mpView removeAnnotations:_annotationArr];
    }

    for (NSDictionary *propertyDict in _propertyListPresentArray ) {
        NSString *addressString = [NSString stringWithFormat:@"%@, %@",[propertyDict valueForKey:@"Property Address1"],[propertyDict valueForKey:@"Property Address2"]];
        [self reverseAddressGeocoder:addressString andInfo:propertyDict];
    }
}


#pragma mark- TableView Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_propertyListPresentArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myTableCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [_propertyListPresentArray objectAtIndex:indexPath.row];
    
    NSString *propertCategory = [dict valueForKey:@"Property Category"];
    if ([propertCategory isEqualToString:@"1"]) {
        cell.propertyCateLbl.text = @"FOR RENT";
        cell.costLbl.text = [NSString stringWithFormat:@"$%@/mon",[dict valueForKey:@"Property Cost"]];
    }
    else {
        cell.propertyCateLbl.text = @"FOR SALE";
        cell.costLbl.text = [NSString stringWithFormat:@"$%@",[dict valueForKey:@"Property Cost"]];
    }
    
    cell.addressLbl.text = [NSString stringWithFormat:@"%@, %@",[dict valueForKey:@"Property Address1"],[dict valueForKey:@"Property Address2"]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_sync(queue, ^{
        NSString *img = [dict valueForKey:@"Property Image 1"];
        NSString *str = @"";
        str = [img stringByReplacingOccurrencesOfString:@"\\"                                                withString:@"/"];
        NSString *string = [NSString stringWithFormat:@"http://%@",str];
        NSURL *imgUrl = [NSURL URLWithString:string];
        NSData *data = [NSData dataWithContentsOfURL:imgUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imgView.image = [UIImage imageWithData:data];
            if (cell.imgView.image == nil) {
                cell.imgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
            }
        });
    });
    
    cell.likeBtn.selected = NO;
    for (Property *property in _myFavoriteArray) {
        if ([property.iD isEqualToString:[dict valueForKey:@"Property Id"]]) {
            cell.likeBtn.selected = YES;
        }
            
    }
    cell.likeBtn.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)heartProperty:(NSInteger)index like:(BOOL)like {
    if (like) {
        NSDictionary *propertyDict = [_propertyListPresentArray objectAtIndex:index];
        Property *property = (Property*)[NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:_appdelegate.managedObjectContext];
        property.myUserId = _uid;
        property.iD = [propertyDict valueForKey:@"Property Id"];
        property.name = [propertyDict valueForKey:@"Property Name"];
        property.type = [propertyDict valueForKey:@"Property Type"];
        property.category = [propertyDict valueForKey:@"Property Category"];
        property.address1 = [propertyDict valueForKey:@"Property Address1"];
        property.address2 = [propertyDict valueForKey:@"Property Address2"];
        property.zipCode = [propertyDict valueForKey:@"Property Zip"];
        property.cost = [propertyDict valueForKey:@"Property Cost"];
        property.size = [propertyDict valueForKey:@"Property Size"];
        property.descri = [propertyDict valueForKey:@"Property Desc"];
        property.sellerUid = [propertyDict valueForKey:@"User Id"];
        property.latitude = [propertyDict valueForKey:@"Property Latitude"];
        property.longitutde = [propertyDict valueForKey:@"Property Longitude"];
        property.imagePath = [propertyDict valueForKey:@"Property Image 1"];
        
        NSError *insertError;
        if (![_appdelegate.managedObjectContext save:&insertError]) {
            NSLog(@"Insert Data error, %@",[insertError description]);
        }
        [self fetchMyFavoriteListFromCoreData];
        [self.myTableView.tbView reloadData];
    }
    else {
        NSDictionary *propertyDict = [_propertyListPresentArray objectAtIndex:index];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_sync(queue, ^{
            for (Property *property in _myFavoriteArray) {
                if ([property.iD isEqualToString:[propertyDict valueForKey:@"Property Id"]]) {
                    [_appdelegate.managedObjectContext deleteObject:property];
                }
            }
            NSError *deleteError;
            if (![_appdelegate.managedObjectContext save:&deleteError]) {
                NSLog(@"Delete Data Error %@", [deleteError description]);
            }
        });
        [self fetchMyFavoriteListFromCoreData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView.tbView reloadData];
        });
    }
}


#pragma mark- TextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self reverseGeoCoder:textField.text];
    [self callPropertySearchApi];
    if (self.myMapView) {
        [self showPropertyInMap];
    }
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
            _propertyListPresentArray = [[NSMutableArray alloc] init];
            dispatch_sync(dispatch_get_main_queue(), ^{
            _propertListDataArray = [[NSArray alloc] initWithArray:json];
                
                if ([_fObject.address length]) {
                    
                    for (NSDictionary *propertyDict in _propertListDataArray) {
                        NSString *addressString = [NSString stringWithFormat:@"%@, %@",[propertyDict valueForKey:@"Property Address1"],[propertyDict valueForKey:@"Property Address2"]];
                        if ([addressString isEqualToString:_fObject.address]) {
                            [_propertyListPresentArray addObject:propertyDict];
                        }
                    }
                    
                }
                else {
                    if (![_fObject.costMin length] && ![_fObject.costMax length]) {
                       _propertyListPresentArray = [NSMutableArray arrayWithArray:_propertListDataArray];
                    }
                    else if ([_fObject.costMin length] && ![_fObject.costMax length]) {
                        for (NSDictionary *propertyDict in _propertListDataArray) {
                            if ([[propertyDict valueForKey:@"Property Cost"] doubleValue] >= [_fObject.costMin doubleValue]) {
                                [_propertyListPresentArray addObject:propertyDict];
                            }
                        }
                    }
                    else if ([_fObject.costMin length] && ![_fObject.costMax length]) {
                        for (NSDictionary *propertyDict in _propertListDataArray) {
                            if ([[propertyDict valueForKey:@"Property Cost"] doubleValue] <= [_fObject.costMax doubleValue]) {
                                [_propertyListPresentArray addObject:propertyDict];
                            }
                        }
                    }
                    else {
                        for (NSDictionary *propertyDict in _propertListDataArray) {
                            if ([[propertyDict valueForKey:@"Property Cost"] doubleValue] >= [_fObject.costMin doubleValue] && [[propertyDict valueForKey:@"Property Cost"] doubleValue] <= [_fObject.costMax doubleValue] ) {
                                [_propertyListPresentArray addObject:propertyDict];
                            }
                        }
                    }
                }
                [self fetchMyFavoriteListFromCoreData];
                [self.myTableView.tbView reloadData];
            });
        }
    }] resume];
}

-(NSURLRequest *)getPropertySearchNSURLRequest{
    
    NSURL *requestURL = [NSURL alloc];
    
    if ([_fObject.address length]) {
        requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?all"];
    }
    else {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/getproperty.php?psearch&pname=&pptype=%@&ploc=%@&pcatid=%@",_fObject.type,_zipCodeTextField.text,_fObject.category]];
    }
    
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

@end
