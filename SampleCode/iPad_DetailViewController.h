//
//  iPad_DetailViewController.h
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewProtocol.h"
#import "DetailViewProtocol.h"

@interface iPad_DetailViewController : UIViewController <MasterViewProtocol, UISplitViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) id<DetailViewProtocol> delegate;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, assign) UIInterfaceOrientation lastRotation;

-(void)handleWebViewLandscapeLayout;
-(void)handleWebViewPortraitLayout;

@end
