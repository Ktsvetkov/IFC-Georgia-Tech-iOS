//
//  PopUpView.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/10/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIViewController

@property (retain) UIView *box;
@property (retain) UIView *titleView;
@property (retain) UIView *containerView;
@property int boxWidth;
@property int boxHeight;
@property int containerHeight;
@property int containerWidth;
@property int screenHeight;
@property int screenWidth;

@end
