//  Created by James Diomede on 4/17/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import "SoundCloudTableViewController.h"
#import "SoundCloudSearchViewController.h"

@implementation SoundCloudTableViewController

@synthesize masterViewController;
@synthesize youTubeTableView;
@synthesize searchResults;

- (void)dealloc
{
    masterViewController = nil;
    [youTubeTableView release];
    [searchResults release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style masterViewController:(UIViewController*)pC
{
    self = [super initWithStyle:style];
    if (self) {
        self.masterViewController = pC;
        self.searchResults = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.youTubeTableView = [[[UITableView alloc] init] autorelease];
    self.tableView = self.youTubeTableView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    
    // Configure the cell...
    NSArray *allKeys = self.searchResults.allKeys;
    NSString *key = [allKeys objectAtIndex:[indexPath row]];
    NSString *artist = [[self.searchResults valueForKey:key] objectAtIndex:SOUNDCLOUD_ARTIST];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",artist,key];
    cell.imageView.image = [[self.searchResults valueForKey:key] objectAtIndex:SOUNDCLOUD_THUMBNAIL];
    NSInteger duration = [[[self.searchResults valueForKey:key] objectAtIndex:SOUNDCLOUD_DURATION] intValue];
    NSInteger minutes = duration / 60;
    NSInteger seconds = duration % 60;
    if (minutes >= 60) {
        NSInteger hours = minutes / 60;
        minutes = minutes % 60;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSArray *allKeys = self.searchResults.allKeys;
    NSString *title = [allKeys objectAtIndex:[indexPath row]];
    NSArray *value = [searchResults valueForKey:title];
    NSString *tid = [value objectAtIndex:SOUNDCLOUD_TID];
    NSString *htmlString = [NSString stringWithFormat:@" \
                            <html> \
                            <head> \
                            <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 640\"/> \
                            </head> \
                            <body style=\"background:#FFF;margin-top:0px;margin-left:0px\"> \
                            <div id=\"player\"> \
                            <iframe width=\"640\" height=\"165\" scrolling=\"no\" frameborder=\"no\" src=\"http://w.soundcloud.com/player/?url=http://api.soundcloud.com/tracks/%@&#038;show_artwork=true\"></iframe> \
                            </div> \
                            </body> \
                            </html>",tid];
    
    [[((iPad_MasterViewController*)self.masterViewController) delegate] loadHTMLString:htmlString];
}

@end
