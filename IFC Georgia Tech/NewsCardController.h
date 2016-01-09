//
//  NewsCardController.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/11/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "PopUpView.h"
#import "NewsPost.h"

@interface NewsCardController : PopUpView

@property (strong, nonatomic) NewsPost *newsPost;

@end
