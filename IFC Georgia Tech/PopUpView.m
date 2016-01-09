//
//  PopUpView.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/10/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "PopUpView.h"

@interface PopUpView ()


@end

@implementation PopUpView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFrame];
    [self setUpBox];
    [self setUpTitleView];
    [self setUpContainerView];
    [self makeVisibleTransition];
}

-(void)setUpFrame {
    [self.view setAlpha:0];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
}

-(void)setUpBox {
    
    self.boxWidth = .95 * self.screenWidth;
    self.boxHeight = .9 * self.screenHeight;
    
    CGRect boxFrame = CGRectMake(0, 0, self.boxWidth, self.boxHeight);
    
    self.box = [[UIView alloc] initWithFrame:boxFrame];
    self.box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    self.box.center = self.view.center;
    self.box.layer.cornerRadius = 20;
    self.box.clipsToBounds = YES;
    [self.view addSubview:self.box];
}

-(void)setUpTitleView {
    int boxWidth = self.box.frame.size.width;
    CGRect titleFrame = CGRectMake(0, 0, boxWidth, 50);
    self.titleView = [[UIView alloc] initWithFrame:titleFrame];
    
    CGRect bottomBarFrame = CGRectMake(0, 47, boxWidth, 1);
    UIView *bottomToolBorder = [[UIView alloc] initWithFrame:bottomBarFrame];
    bottomToolBorder.backgroundColor = [UIColor darkGrayColor];
    [self.titleView addSubview:bottomToolBorder];
    [self.box addSubview: self.titleView];
    [self setUpCloseButton];
}

-(void)setUpCloseButton {
    int boxWidth = self.titleView.frame.size.width;
    //int boxHeight = self.titleView.frame.size.height;

    CGRect closeButtonFrame = CGRectMake(boxWidth - 45, 5, 40, 40);
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"xClose3.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBox) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:closeButton];
}

-(void)setUpContainerView {
    self.containerHeight = self.boxHeight - 50;
    self.containerWidth = self.boxWidth;

    CGRect containerViewFrame = CGRectMake(0, 50, self.containerWidth, self.containerHeight);
    self.containerView = [[UIView alloc] initWithFrame:containerViewFrame];
    [self.box addSubview:self.containerView];
}

-(void)closeBox
{
    [UIView animateWithDuration:0.2
                     animations:^{self.view.alpha = 0.0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
}

-(void)makeVisibleTransition {
    [UIView animateWithDuration:0.2
                     animations:^{[self.view setAlpha:1];}
                     completion:^(BOOL finished){}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
