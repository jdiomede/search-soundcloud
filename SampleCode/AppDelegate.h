//
//  AppDelegate.h
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPad_MasterViewController.h"
#import "iPad_DetailViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) iPad_MasterViewController *masterViewController;
@property (nonatomic, retain) iPad_DetailViewController *detailViewController;
@property (nonatomic, retain) UINavigationController *masterNavigationController;
@property (nonatomic, retain) UINavigationController *detailNavigationController;
@property (nonatomic, retain) UISplitViewController *splitViewController;

@end
