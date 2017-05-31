//
//  ViewController.m
//  LMUpdateView
//
//  Created by linhongmin on 2017/5/31.
//  Copyright © 2017年 linhongmin. All rights reserved.
//

#import "ViewController.h"

#import "LMUpdateVersionManage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LMUpdateVersionManage checkVersionInController:self];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
