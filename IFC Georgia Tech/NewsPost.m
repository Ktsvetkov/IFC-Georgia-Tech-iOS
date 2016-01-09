//
//  NewsPost.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 5/4/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "NewsPost.h"

@implementation NewsPost

-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.mediaType = [[NSString alloc] init];
        self.message = [[NSString alloc] init];
        self.timeSince1970 = 0;
        self.pictureLinks = [[NSMutableArray alloc] init];
        self.hasPictures = 0;
        self.picture = nil;
    }
    return self;
}

@end
