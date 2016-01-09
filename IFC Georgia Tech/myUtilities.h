//
//  myUtilities.h
//  GT Pike
//
//  Created by Kamen Tsvetkov on 4/19/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface myUtilities : NSObject

+(UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;
+(CGRect)cropRectForImage:(UIImage *)image;
+(CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end
