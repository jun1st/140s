//
//  Tweet+CoreData.h
//  140Pulse
//
//  Created by qijun on 14/9/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import "Tweet.h"

@interface Tweet (CoreData)

+(NSNumber *)nextTweetIdWithManageObjectContext:(NSManagedObjectContext *)managedObjectContext;

+(void)insertTweetWithContent:(NSString *)content target:(NSString *)target inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+(NSArray *)tweetsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (BOOL)isSentToTarget:(NSString *)target;

@end
