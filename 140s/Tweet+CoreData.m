//
//  Tweet+CoreData.m
//  140Pulse
//
//  Created by qijun on 14/9/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "Tweet+CoreData.h"

@implementation Tweet (CoreData)

+(NSNumber *)nextTweetIdWithManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [request setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweetId" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
    }
    
    if (results && results.count > 0)
    {
        Tweet *tweet = (Tweet *)[results objectAtIndex:0];
        return [NSNumber numberWithInt: tweet.tweetId.intValue + 1];
    }
    else
    {
        return @1;
    }
    
}

+(void)insertTweetWithContent:(NSString *)content target:(NSString *)target inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([@"" isEqualToString:content])
    {
        return;
    }
    
    NSUInteger contentHash = [content hash];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    NSPredicate *sameContentPredicate = [NSPredicate predicateWithFormat:@"contentHash == %ld", contentHash];
    request.predicate = sameContentPredicate;
    request.fetchLimit = 1;
    
    NSArray *tweets = [managedObjectContext executeFetchRequest:request error:nil];
    
    if (tweets && tweets.count > 0)
    {
        Tweet *tweet = (Tweet *)[tweets objectAtIndex:0];
        if ([tweet.target rangeOfString:target options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
            tweet.target = [[tweet.target stringByAppendingString:@","] stringByAppendingString: target];
            tweet.postTime = [NSDate date];
        }
    }
    else
    {
        Tweet *newTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:managedObjectContext];
        newTweet.tweetId = [Tweet nextTweetIdWithManageObjectContext:managedObjectContext];
        newTweet.content = content;
        newTweet.target = target;
        newTweet.contentHash = [NSNumber numberWithInteger:contentHash];
        newTweet.postTime = [NSDate date];
    }
    
    [managedObjectContext save:nil];
}

+(NSArray *)tweetsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postTime" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return [managedObjectContext executeFetchRequest:request error:nil];
}

- (BOOL)isSentToTarget:(NSString *)target
{
    if ([self.target rangeOfString:target options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return YES;
    }
    else{
        return NO;
    }
}

@end
