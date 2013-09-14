//
//  Tweet.h
//  140Pulse
//
//  Created by qijun on 14/9/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * postTime;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSNumber * tweetId;
@property (nonatomic, retain) NSNumber * contentHash;

@end
