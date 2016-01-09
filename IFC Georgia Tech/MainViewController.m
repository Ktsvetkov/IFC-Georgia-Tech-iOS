//
//  MainViewController.m
//  IFC Georgia Tech
//
//  Created by Kamen Tsvetkov on 12/12/14.
//  Copyright (c) 2014 Kamen Tsvetkov. All rights reserved.
//

#import "MainViewController.h"
#import "NewsViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UIButton *fraternitiesButton;
@property (weak, nonatomic) IBOutlet UIButton *gameDayButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.newsButton addTarget:self
               action:@selector(goToNews:) forControlEvents:UIControlEventTouchDown];}

- (void)goToNews:(UIButton*) sender {
    NewsViewController *oView = [[NewsViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
