//
//  TweetsViewController.h
//  140Pulse
//
//  Created by qijun on 14/9/13.
//  Copyright (c) 2013 fengqijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

-(IBAction)back:(id)sender;

@end
