//
//  ViewController.m
//  LMCityPickView
//
//  Created by linhongmin on 2017/6/4.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "ViewController.h"
#import "LMCityPickView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextFilef;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)click:(id)sender {
    [LMCityPickView showWithSelectedBlock:^(NSString *province, NSString *ciry, NSString *area, NSString *zipcode) {
        _addressLabel.text=[NSString stringWithFormat:@"%@%@%@",province,ciry,area];
        _zipcodeTextFilef.text=zipcode;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
