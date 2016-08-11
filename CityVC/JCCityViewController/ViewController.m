//
//  ViewController.m
//  JCCityViewController
//
//  Created by wang on 16/8/10.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ViewController.h"
#import "JCCityViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushCityVC:(id)sender {
    JCCityViewController *cityVC = [[JCCityViewController alloc]init];
    cityVC.callBlock = ^(NSString *city){
        [_cityButton setTitle:city forState:0];
        
};
    [self.navigationController pushViewController:cityVC animated:YES];

}

@end
