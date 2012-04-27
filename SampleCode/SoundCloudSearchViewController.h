//  Created by James Diomede on 4/15/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "TBXMLReader.h"
#import "iPad_MasterViewController.h"
#import "iPad_DetailViewController.h"
#import "SoundCloudTableViewController.h"

@interface SoundCloudSearchViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, retain) UIViewController *masterViewController;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UISearchBar *mainSearchBar;
@property (nonatomic, retain) SoundCloudTableViewController *soundCloudTableView;
@property (nonatomic, assign) BOOL cancelSearch; 

-(id)initWithMasterViewController:(UIViewController*)pC;
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
-(void)parseData:(NSData*)data;

@end

