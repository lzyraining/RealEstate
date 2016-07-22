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
@property (nonatomic, strong) typePopoverViewController *popover;
@property (weak, nonatomic) IBOutlet UILabel *prpTypeLbl;
- (IBAction)backBtn_Tapped:(UIButton *)sender;

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
                
                // Set the correct sourceRect given the sender's bounds
                popoverPresentationController.sourceRect = ((UIView *)sender).bounds;
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
@end
