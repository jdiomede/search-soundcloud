//  Created by James Diomede on 4/17/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface SoundCloudTableViewController : UITableViewController

@property (nonatomic, retain) UIViewController *masterViewController;
@property (nonatomic, retain) UITableView *youTubeTableView;
@property (nonatomic, retain) NSMutableDictionary *searchResults;

-(id)initWithStyle:(UITableViewStyle)style masterViewController:(UIViewController*)pC;

@end
