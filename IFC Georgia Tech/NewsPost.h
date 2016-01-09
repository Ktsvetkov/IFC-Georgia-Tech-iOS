//
//  NewsPost.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 5/4/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsPost : NSObject {}

@property (copy, nonatomic) NSString *mediaType;
@property (copy, nonatomic) NSString *message;
@property (nonatomic) NSInteger timeSince1970;
@property (nonatomic) NSMutableArray *pictureLinks;
@property int hasPictures;
@property (nonatomic) UIImage *picture;

@end
