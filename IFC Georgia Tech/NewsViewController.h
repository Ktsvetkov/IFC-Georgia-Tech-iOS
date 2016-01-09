//
//  NewsViewController.h
//  IFC Georgia Tech
//
//  Created by Kamen Tsvetkov on 9/28/15.
//  Copyright © 2015 Kamen Tsvetkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableArray *posts;

@end
