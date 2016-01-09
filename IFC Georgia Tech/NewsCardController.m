//
//  NewsCardController.m
//  GT Pike
//
//  Created by Kamen Tsvetkov on 8/11/15.
//  Copyright (c) 2015 Kamen Tsvetkov. All rights reserved.
//

#import "UIImage+animatedGIF.h"
#import "NewsCardController.h"
#import "myUtilities.h"

@interface NewsCardController ()

@property (strong, nonatomic) UIImageView *currentPicture;
@property (strong, nonatomic) UIScrollView *currentScroll;
@property (strong, nonatomic) UITextView *currentText;
@property (strong, nonatomic) NSData *picData;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation NewsCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPicture];
    [self setUpText];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}

-(void)indicator:(BOOL)animated{
    [self.currentText flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpPicture {
    
    CGRect pictureFrame = CGRectMake(0, 0, 0, 0);
    
    if (self.newsPost.hasPictures) {
        pictureFrame = CGRectMake(5, 5, self.containerWidth-10, self.containerHeight/2 - 10);
    }
    
    self.currentPicture = [[UIImageView alloc] initWithFrame:pictureFrame];
    if (self.newsPost.picture == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading3" withExtension:@"gif"];
        self.currentPicture.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    } else {
        self.currentPicture.image = self.newsPost.picture;
    }
    self.currentPicture.contentMode = UIViewContentModeScaleAspectFit;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *urlString = @"";
        if ([self.newsPost hasPictures])
            urlString = [[self.newsPost pictureLinks] objectAtIndex:0];
        
        NSURL *postURL = [NSURL URLWithString: urlString];
        
        self.picData = nil;
        self.picData = [NSData dataWithContentsOfURL:postURL];
        if (self.picData == nil) {
            UIImage *memberPic = [UIImage imageNamed:@"MemberDefaultIcon.jpg"];
            self.picData = UIImageJPEGRepresentation(memberPic, 1.0);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *toSet = [UIImage imageWithData:self.picData];
            
            if ([self.newsPost.mediaType isEqualToString:@"instagram"]) {
                
                toSet = [myUtilities replaceColor: [myUtilities colorWithHexString:@"FFFEFF"] inImage:toSet withTolerance:50];
                
                CGRect newRect = [myUtilities cropRectForImage:toSet];
                CGImageRef imageRef = CGImageCreateWithImageInRect(toSet.CGImage, newRect);
                toSet = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
            }
            
            self.currentPicture.image = toSet;
        });
        
    });

    [self.containerView addSubview:self.currentPicture];
    
    CGRect bottomPicFrame = CGRectMake(0, 0, 0, 0);
    if (self.newsPost.hasPictures) {
        bottomPicFrame = CGRectMake(0, self.containerHeight/2 - 1, self.containerWidth, 1);
    }
    UIView *bottomPicBorder = [[UIView alloc] initWithFrame:bottomPicFrame];
    bottomPicBorder.backgroundColor = [UIColor blackColor];
    [self.titleView addSubview:bottomPicBorder];
    [self.containerView addSubview:bottomPicBorder];
}

-(void) setUpText {
    
    CGRect textFrame = CGRectMake(0, 0, self.containerWidth, self.containerHeight);
    
    if (self.newsPost.hasPictures) {
        textFrame = CGRectMake(0, self.containerHeight/2, self.containerWidth, self.containerHeight/2);
    }
    
    self.currentText = [[UITextView alloc] initWithFrame:textFrame];
    self.currentText.text = self.newsPost.message;
    self.currentText.editable = NO;
    self.currentText.selectable = YES;

    [self.currentText setFont:[UIFont systemFontOfSize:16]];
    self.currentText.frame = textFrame;
    self.currentText.dataDetectorTypes = UIDataDetectorTypeLink;
    //[self.currentText flashScrollIndicators];
    //[self.currentText sizeToFit];


    [self.containerView addSubview: self.currentText];
    [self.containerView bringSubviewToFront:self.currentText];
    self.currentText.userInteractionEnabled = YES;
}


@end
