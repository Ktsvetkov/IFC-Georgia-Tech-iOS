//
//  NewsViewController.m
//  IFC Georgia Tech
//
//  Created by Kamen Tsvetkov on 9/28/15.
//  Copyright © 2015 Kamen Tsvetkov. All rights reserved.
//

#import "UIImage+animatedGIF.h"
#import "NewsViewController.h"
#import "MainViewController.h"
#import "NewsPostCell.h"
#import "myUtilities.h"
#import "NewsPost.h"
#import "NewsCardController.h"

@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *myTable1;
@property (nonatomic) NSData *postData;
@property int numberOfThreads;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressBar;
@property (retain, nonatomic) NewsCardController *newsCardController;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.errorMessage.hidden = YES;
    [self.progressBar startAnimating];
    self.progressBar.hidesWhenStopped = YES;
    
    [self.backButton addTarget:self
                        action:@selector(goBack:)
              forControlEvents:UIControlEventTouchDown];
    self.posts = [[NSMutableArray alloc] init];
    self.myTable1.delegate=self;
    self.myTable1.dataSource=self;
    self.myTable1.tableFooterView = [UIView new];
    [self.myTable1 setSeparatorInset:UIEdgeInsetsZero];
    [self.myTable1 setLayoutMargins:UIEdgeInsetsZero];
    self.myTable1.tableFooterView.backgroundColor = [UIColor blackColor];
    
    [self getFacebookJsonData];
}


- (void)getFacebookJsonData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *postDataString = @"https://graph.facebook.com/v2.3/295206497199797/feed?access_token=488056298015418|ev5kTyKcCZU5sQD0s3za_nB9HhU";
        
        NSString* webReadyPostDataString = [postDataString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *postDataURL = [[NSURL alloc]initWithString:webReadyPostDataString];
        
        self.postData = [NSData dataWithContentsOfURL:postDataURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.postData == nil) {
                [self.progressBar stopAnimating];
                self.errorMessage.hidden = NO;
            } else {
                NSError *localError = nil;
                NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:self.postData options:NSJSONReadingMutableContainers error:&localError];
                NSArray *results = [parsedObject valueForKey:@"data"];
                for (NSDictionary *dic in results){
                    NSString *message = (NSString*) [dic valueForKey:@"message"];
                    NSString *dateString = (NSString*) [dic valueForKey:@"updated_time"];
                    NSString *pictureURL = @"";
                    pictureURL = (NSString*) [dic valueForKey:@"object_id"];
                    NSMutableArray *pictureLinks = [[NSMutableArray alloc]init];
                    if (pictureURL != nil && ![pictureURL isEqualToString:@""]) {
                        pictureURL = [@"https://graph.facebook.com/" stringByAppendingString:pictureURL];
                        pictureURL = [pictureURL stringByAppendingString:@"/picture?height=620&width=620"];
                        [pictureLinks addObject:pictureURL];
                    } else {
                        pictureURL = (NSString*) [dic valueForKey:@"picture"];
                        if (pictureURL != nil && ![pictureURL isEqualToString:@""]) {
                            [pictureLinks addObject:pictureURL];
                        }
                    }
                    
                    if (message != nil && dateString != nil) {
                        NewsPost *toAdd = [[NewsPost alloc] init];
                        
                        dateString = [dateString substringToIndex:[dateString length] - 5];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                        [formatter setLocale:posix];
                        NSDate *date = [formatter dateFromString:dateString];
                        
                        if ([pictureLinks count] != 0) {
                            [toAdd setHasPictures:1];
                        }
                        [toAdd setTimeSince1970:[date timeIntervalSince1970]];
                        [toAdd setMessage:message];
                        [toAdd setPictureLinks:pictureLinks];
                        [toAdd setMediaType: @"facebook"];
                        [self.posts addObject:toAdd];
                        
                    }
                }
                [self sortPosts];
                self.numberOfThreads = 5;
                for (int i=0; i < self.numberOfThreads; i++) {
                    [self getPostPics: i];
                }
                [self.myTable1 reloadData];
            }
            [self.progressBar stopAnimating];
        });
        
    });
    
}

- (void) sortPosts {
    for (int i = 0; i < [self.posts count]; i++) {
        for (int j = 1; j < [self.posts count]; j++) {
            NewsPost *tempToFlip = [self.posts objectAtIndex: j-1];
            NewsPost *temp2ToFlip = [self.posts objectAtIndex: j];
            
            if ([tempToFlip timeSince1970] < [temp2ToFlip timeSince1970]){
                [self.posts replaceObjectAtIndex:j-1 withObject:temp2ToFlip];
                [self.posts replaceObjectAtIndex:j withObject:tempToFlip];
            }
        }
    }
}

-(void) getPostPics: (int) postNumber
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NewsPost *currentPost = [self.posts objectAtIndex:postNumber];
        NSString *urlString = @"";
        if ([currentPost hasPictures])
            urlString = [[currentPost pictureLinks] objectAtIndex:0];
        
        NSURL *postURL = [NSURL URLWithString: urlString];
        
        NSData *picData = [NSData dataWithContentsOfURL:postURL];
        
        if (picData == nil) {
            UIImage *memberPic = [UIImage imageNamed:@"MemberDefaultIcon.jpg"];
            picData = UIImageJPEGRepresentation(memberPic, 1.0);
        }
        
        UIImage *toSet = [UIImage imageWithData:picData];
        
        if ([currentPost.mediaType isEqualToString:@"instagram"]) {
            
            toSet = [myUtilities replaceColor: [myUtilities colorWithHexString:@"FFFEFF"] inImage:toSet withTolerance:50];
            CGRect newRect = [myUtilities cropRectForImage:toSet];
            CGImageRef imageRef = CGImageCreateWithImageInRect(toSet.CGImage, newRect);
            toSet = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        
        [currentPost setPicture:toSet];
        [self.posts replaceObjectAtIndex:postNumber withObject:currentPost];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myTable1 reloadData];
            
            if (postNumber < [self.posts count] - self.numberOfThreads) {
                [self getPostPics: postNumber + self.numberOfThreads];
            }
            
        });
    });
    
}


- (void)goBack:(UIButton*) sender {
    MainViewController *oView = [[MainViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

// sections "should be 1"
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// height of a row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger toReturn;
    if ([[self.posts objectAtIndex:indexPath.row] hasPictures]) {
        toReturn = 200;
    } else {
        toReturn = 59;
    }
    return toReturn;
}

// total rows in each section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger toReturn;
    if (self.posts == nil || [self.posts count] == 0) {
        toReturn = 0;
        
    } else {
        toReturn = [self.posts count];
    }
    return toReturn;
}

//dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    NewsPostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NewsPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (self.posts == nil || [self.posts count] == 0) {
        self.myTable1.hidden = YES;
    } else {
        NewsPost *currentPost = [self.posts objectAtIndex:indexPath.row];
        
        NSString *postMessage = [currentPost message];
        const CGFloat fontSize = 14;
        UIFont *regularFont = [UIFont italicSystemFontOfSize:fontSize];
        NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                regularFont,
                                NSFontAttributeName,
                                nil];
        NSMutableAttributedString *attributedPostMessage = [[NSMutableAttributedString alloc] initWithString:postMessage attributes:attrs];
        
        
        cell.textLabel.numberOfLines = 3;
        [cell.textLabel setAttributedText:attributedPostMessage];
        
        
        UIImage *originalImage = nil;
        
        if ([[currentPost mediaType] isEqualToString:@"instagram"]) {
            originalImage = [UIImage imageNamed:@"InstagramLogo.jpg"];
        } else if ([[currentPost mediaType] isEqualToString:@"twitter"]) {
            originalImage = [UIImage imageNamed:@"TwitterLogo2.jpg"];
        } else if ([[currentPost mediaType] isEqualToString:@"facebook"]) {
            originalImage = [UIImage imageNamed:@"FacebookLogo2.jpg"];
        }
        
        cell.imageView.image =  originalImage;
        
        if ([currentPost picture] == nil) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading3" withExtension:@"gif"];
            cell.imageView2.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        } else {
            cell.imageView2.image = [currentPost picture];
        }
        
        if (![currentPost hasPictures]) {
            cell.imageView2.hidden = YES;
        } else {
            cell.imageView2.hidden = NO;
        }
        
    }
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.newsCardController = [[NewsCardController alloc] init];
    self.newsCardController.newsPost = self.posts[indexPath.row];
    [self.view addSubview: self.newsCardController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
