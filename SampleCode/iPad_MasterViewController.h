//
//  iPad_MasterViewController.h
//  SampleCode
//
//  Created by James Diomede on 4/24/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewProtocol.h"
#import "DetailViewProtocol.h"
#import "SoundCloudSearchViewController.h"

@interface iPad_MasterViewController : UIViewController <DetailViewProtocol>

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) id<MasterViewProtocol> delegate;
@property (nonatomic, assign) UIInterfaceOrientation lastRotation;

@end
