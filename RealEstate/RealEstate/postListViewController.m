//
//  postListViewController.m
//  RealEstate
//
//  Created by Shuting lang on 7/26/16.
//  Copyright © 2016 Zhuoyu. All rights reserved.
//

#import "postListViewController.h"
#import "CustListTableViewCell.h"
#import "MyPostViewController.h"

@interface postListViewController (){

    NSMutableArray *resultArr;
    NSString *prpid;
    NSString *resp;

}
- (IBAction)backBtn_Tapped:(UIButton *)sender;
- (IBAction)addNewBtn_Tapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *postListTBView;


@end

@implementation postListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{

    [self getPrpListData];

}

-(void)getPrpListData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/getproperty.php?all&userid=%@",[defaults objectForKey:@"kUid"]];
    //NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:str];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                resultArr = [NSMutableArray arrayWithArray:json];
                //NSLog(@"%@",resultArr);
                [self.postListTBView reloadData];
            });
        }
        
    }] resume];
}

#pragma -mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [resultArr count];
    
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ListCell";
    CustListTableViewCell *cell = [_postListTBView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSObject *currentPrp = [resultArr objectAtIndex:indexPath.row];
    cell.editLbl.layer.cornerRadius = 10.0;
    cell.swipeLbl.layer.cornerRadius = 10.0;
    cell.addr1Lbl.text = [currentPrp valueForKey:@"Property Address1"];
    cell.addr2Lbl.text = [currentPrp valueForKey:@"Property Address2"];
    cell.typeSizeLbl.text = [NSString stringWithFormat:@"%@,%@",[currentPrp valueForKey:@"Property Type"],[currentPrp valueForKey:@"Property Size"]];
    if ([[currentPrp valueForKey:@"Property Category"] intValue]==1) {
        cell.categoryLbl.text = @"For Sell";
        cell.costLbl.text = [NSString stringWithFormat:@"$%@",[currentPrp valueForKey:@"Property Cost"]];
    }else{
        cell.categoryLbl.text = @"For Rent";
        cell.costLbl.text = [NSString stringWithFormat:@"$%@/mo",[currentPrp valueForKey:@"Property Cost"]];
    }
    cell.addDateLbl.text = [currentPrp valueForKey:@"Property Published Date"];
    NSString *imgurl = [NSString stringWithFormat:@"http://%@",[currentPrp valueForKey:@"Property Image 1"]];
    NSURL *url = [NSURL URLWithString:imgurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if ([imgurl isEqualToString:@""]) {
        cell.imgView.image = [UIImage imageNamed:@"photo_not_ava.jpg"];
    }else{
        cell.imgView.image = [UIImage imageWithData:data];
        prpid = [currentPrp valueForKey:@""];
    }
    
    return cell;
    
};

#pragma -mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
    [controller setCurrentPrp:[resultArr objectAtIndex:indexPath.row]];
    [controller setIsEdit:YES];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteProperty:indexPath];
        [resultArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
}

-(void)deleteProperty:(NSIndexPath *)indexpath{

    NSString *deleteStr = [NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/register.php?property&delete&pptyid=%@",[[resultArr objectAtIndex:indexpath.row] valueForKey:@"Property Id"]];
    NSURL *url = [NSURL URLWithString:deleteStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            resp = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",resp);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([resp containsString:@"true"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This property has been deleted!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSLog(@"OOOOOOKKKKKKKK");
                        
                        
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    
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

- (IBAction)backBtn_Tapped:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addNewBtn_Tapped:(UIButton *)sender {
    
    MyPostViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
    [controller setIsEdit:NO];
    [self presentViewController:controller animated:YES completion:nil];

    
}
@end
