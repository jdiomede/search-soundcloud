//
//  iPad_MasterViewController.m
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import "iPad_MasterViewController.h"

@interface iPad_MasterViewController ()

@end

@implementation iPad_MasterViewController

@synthesize mainView;
@synthesize viewController;
@synthesize delegate = _delegate;
@synthesize lastRotation;

- (void)dealloc
{
    self.delegate = nil;
    [mainView release];
    [viewController release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.lastRotation = UIInterfaceOrientationPortrait;
    }
    return self;
}

# pragma mark - View Management

- (void)loadView
{
    [self.navigationController.navigationBar setHidden:YES];
    self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 748)] autorelease];
    self.viewController = [[[SoundCloudSearchViewController alloc] initWithMasterViewController:self] autorelease];
    [self.mainView addSubview:self.viewController.view];
    self.view = self.mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    if ( (currentOrientation == UIInterfaceOrientationPortrait ||
          currentOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
        self.lastRotation = UIInterfaceOrientationPortrait;
    } else if ( (currentOrientation == UIInterfaceOrientationLandscapeLeft ||
                 currentOrientation == UIInterfaceOrientationLandscapeRight) ) {
        self.lastRotation = UIInterfaceOrientationLandscapeLeft;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
