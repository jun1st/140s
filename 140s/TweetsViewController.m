//
//  TweetsViewController.m
//  140Pulse
//
//  Created by qijun on 14/9/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "TweetsViewController.h"
#import "Tweet+CoreData.h"
#import "NSDate+Helper.h"
#import <CoreText/CoreText.h>

@interface TweetsViewController ()

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, strong) UIFont *timeFont;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, strong) UIColor *timeColor;
@property (nonatomic, strong) NSDictionary *contentAttributes;
@property (nonatomic, strong) NSDictionary *timeAttributes;
@property (nonatomic, strong) UIImage *weiboImage;
@property (nonatomic, strong) UIImage *twitterImage;

@end

@implementation TweetsViewController

-(UIFont *)contentFont
{
    if (!_contentFont)
    {
        _contentFont = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    }
    
    return _contentFont;
}

-(UIFont *)timeFont
{
    if (!_timeFont)
    {
        _timeFont = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    }
    
    return _timeFont;
}

-(UIColor *)contentColor
{
    if (!_contentColor)
    {
        _contentColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1];
    }
    
    return _contentColor;
}

-(NSDictionary *)contentAttributes
{
    if(!_contentAttributes)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setLineSpacing:4] ;
        _contentAttributes = @{
                               NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:12.0f],
                               NSParagraphStyleAttributeName: paragraphStyle
                               };
    }
    
    return _contentAttributes;
}

-(UIColor *)timeColor
{
    if (!_timeColor)
    {
        _timeColor = [UIColor colorWithRed:159.0/255 green:160.0/255 blue:160.0/255 alpha:1];
    }
    
    return _timeColor;
}

-(NSDictionary *)timeAttributes
{
    if (!_timeAttributes)
    {
        _timeAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:12.0f]};
    }
    
    return _timeAttributes;
}

-(UIImage *)weiboImage
{
    if (!_weiboImage)
    {
        _weiboImage = [UIImage imageNamed:@"weibo.png"];
    }
    return _weiboImage;
}

-(UIImage *)twitterImage
{
    if (!_twitterImage)
    {
        _twitterImage = [UIImage imageNamed:@"twitter.png"];
    }
    
    return _twitterImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweets = [Tweet tweetsInManagedObjectContext:self.managedObjectContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    CGRect frame = self.tableView.frame;
    frame.origin.y = frame.origin.y + 32;
    self.tableView.frame = frame;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.backgroundColor = [UIColor blueColor];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 300, 4)];
        contentLabel.tag = 1;
        contentLabel.textColor = self.contentColor;
        //contentLabel.backgroundColor = [UIColor redColor];
        contentLabel.font = self.contentFont;
        contentLabel.numberOfLines = 0;
        [cell addSubview:contentLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 200, 16)];
        timeLabel.tag = 2;
        timeLabel.textColor = self.timeColor;
        timeLabel.font = self.timeFont;
        [cell addSubview:timeLabel];
        
        UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 20, 16, 16)];
        weiboImageView.tag = 3;
        [cell addSubview:weiboImageView];
        
        UIImageView *twitterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 20, 16, 16)];
        twitterImageView.tag = 4;
        [cell addSubview:twitterImageView];
    }
    
    Tweet *tweet = (Tweet *)[self.tweets objectAtIndex:indexPath.row];
    
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:1];
    
    //NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tweet.content attributes:self.contentAttributes];
    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
//    CGSize targetSize = CGSizeMake(300, CGFLOAT_MAX);
//    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [tweet.content length]), NULL, targetSize, NULL);
//    CFRelease(framesetter);
    
    CGRect rect = [tweet.content boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX)
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:self.contentAttributes
                                              context:nil];
    CGRect newContentFrame = contentLabel.frame;
    newContentFrame.size.height = ceilf( ceilf(rect.size.height) / 12 + 1 ) * 12;
    contentLabel.frame = newContentFrame;
    contentLabel.text = tweet.content;
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
    CGRect frame = timeLabel.frame;
    frame.origin.y = newContentFrame.origin.y + newContentFrame.size.height;
    timeLabel.frame = frame;
    timeLabel.text = [tweet.postTime stringDaysAgo];
    
    UIImageView *weiboImageView = (UIImageView *)[cell viewWithTag:3];
    if ([tweet isSentToTarget:@"Weibo"])
    {
        weiboImageView.hidden = NO;
        weiboImageView.image = self.weiboImage;
        CGRect frame = weiboImageView.frame;
        frame.origin.y = timeLabel.frame.origin.y;
        weiboImageView.frame = frame;
    }
    else
    {
        weiboImageView.hidden = YES;
    }
    
    UIImageView *twitterImageView = (UIImageView *)[cell viewWithTag:4];
    if ([tweet isSentToTarget:@"Twitter"])
    {
        twitterImageView.hidden = NO;
        twitterImageView.image = self.twitterImage;
        CGRect frame = twitterImageView.frame;
        frame.origin.y = timeLabel.frame.origin.y;
        twitterImageView.frame = frame;
    }
    else
    {
        twitterImageView.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = (Tweet *)[self.tweets objectAtIndex:indexPath.row];
    CGRect rect = [tweet.content boundingRectWithSize:CGSizeMake(280.0f, 6000.0f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:self.contentAttributes
                                              context:nil];
    
    return ceilf(rect.size.height) + 34;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
