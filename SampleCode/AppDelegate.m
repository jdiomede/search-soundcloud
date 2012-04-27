//
//  AppDelegate.m
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

//TODOS (1) implement cancel button: stop search, hide master view in portrait mode

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize masterViewController;
@synthesize detailViewController;
@synthesize masterNavigationController;
@synthesize detailNavigationController;
@synthesize splitViewController;

- (void)dealloc
{
    [_window release];
    [masterViewController release];
    [detailViewController release];
    [masterNavigationController release];
    [detailNavigationController release];
    [splitViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.masterViewController = [[[iPad_MasterViewController alloc] init] autorelease];
        self.detailViewController = [[[iPad_DetailViewController alloc] init] autorelease];
        [self.masterViewController setDelegate:self.detailViewController];
        [self.detailViewController setDelegate:self.masterViewController];
        self.masterNavigationController = [[[UINavigationController alloc]initWithRootViewController:self.masterViewController] autorelease];
        self.detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.detailViewController] autorelease];
        NSArray *viewControllers = [[[NSArray alloc] initWithObjects:self.masterNavigationController, self.detailNavigationController, nil] autorelease];
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        [self.splitViewController setViewControllers:viewControllers];
        [self.splitViewController setDelegate:self.detailViewController];
        
        [self.window setRootViewController:self.splitViewController];
        [self.window addSubview:self.splitViewController.view];
    }
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;    
    UIInterfaceOrientation viewControllerOrientation = self.detailViewController.interfaceOrientation;
    if (UIInterfaceOrientationIsLandscape(deviceOrientation) || 
        UIInterfaceOrientationIsLandscape(viewControllerOrientation) ||
        UIDeviceOrientationIsLandscape(statusBarOrientation) ) {
        NSLog(@"starting in lanscape");
    } else {
        NSLog(@"starting in portrait");
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
