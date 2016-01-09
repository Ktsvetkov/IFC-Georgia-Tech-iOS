//
//  NewsPostCell.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 5/17/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "NewsPostCell.h"

@implementation NewsPostCell

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    /*self.imageView.bounds = CGRectMake(5,5,40,40);
    self.imageView.frame = CGRectMake(5,5,40,40);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.layer.borderWidth = 0;
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;*/
    
    [self.textLabel sizeToFit];
    
    CGRect bounds = self.textLabel.bounds;
    bounds.size.width = self.bounds.size.width - 20;
    self.textLabel.bounds = bounds;
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = 5;
    self.textLabel.frame = frame;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView2 = [[UIImageView alloc] initWithFrame: CGRectMake(0,195,[[UIScreen mainScreen] bounds].size.width,self.frame.size.height-180)];
        self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView2.clipsToBounds = YES;
        [self.contentView addSubview: self.imageView2];

    }
    return self;
}

@end

