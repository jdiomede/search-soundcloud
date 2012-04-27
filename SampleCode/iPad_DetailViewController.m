//
//  iPad_DetailViewController.m
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import "iPad_DetailViewController.h"

@interface iPad_DetailViewController ()

@end

@implementation iPad_DetailViewController

@synthesize mainView;
@synthesize webView;
@synthesize delegate = _delegate;
@synthesize popoverController;
@synthesize lastRotation;

- (void)dealloc
{
    self.delegate = nil;
    [mainView release];
    [webView release];
    [popoverController release];
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

# pragma mark - Split View Control

- (void)loadHTMLString:(NSString *)htmlString
{
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

# pragma mark - View Management

- (void)loadView
{
    self.mainView = [[[UIView alloc] init] autorelease];
    if (self.lastRotation == UIInterfaceOrientationLandscapeLeft) {
        [self.mainView setFrame:CGRectMake(0, 0, 704, 704)];
    } else {
        [self.mainView setFrame:CGRectMake(0, 0, 768, 1004)];
    }
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    
    self.webView = [[[UIWebView alloc] init] autorelease];
    if (self.lastRotation == UIInterfaceOrientationLandscapeLeft) {
        [self handleWebViewLandscapeLayout];
    } else {
        [self handleWebViewPortraitLayout];
    }
    
    NSString *htmlString = [NSString stringWithFormat:@" \
                            <html> \
                            <head> \
                            <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 640\"/> \
                            </head> \
                            <body style=\"background:#FFF;margin-top:0px;margin-left:0px\"> \
                            <div id=\"player\" style=\"text-align: center;\"> \
                            ...Search And Select To Add A Track \
                            </div> \
                            </body> \
                            </html>"];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    [self.mainView addSubview:self.webView];
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

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Search";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    self.popoverController = pc;
    self.popoverController.delegate = self;
    [self.popoverController setPopoverContentSize:CGSizeMake(320, 1004)];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
}

- (void)handleWebViewLandscapeLayout
{
    [self.webView setFrame:CGRectMake(32, 189, 635, 200)];    
}

- (void)handleWebViewPortraitLayout
{
    [self.webView setFrame:CGRectMake(64, 317, 635, 200)];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    if ( (currentOrientation == UIInterfaceOrientationPortrait ||
          currentOrientation == UIInterfaceOrientationPortraitUpsideDown) ) {
        self.lastRotation = UIInterfaceOrientationPortrait;
        [self handleWebViewPortraitLayout];
    } else if ( (currentOrientation == UIInterfaceOrientationLandscapeLeft ||
                 currentOrientation == UIInterfaceOrientationLandscapeRight) ) {
        self.lastRotation = UIInterfaceOrientationLandscapeLeft;
        [self handleWebViewLandscapeLayout];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
