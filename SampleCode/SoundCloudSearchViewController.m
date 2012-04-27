//  Created by James Diomede on 4/15/12.
//  Copyright (c) 2012 Diomede, Inc. All rights reserved.
//

#import "SoundCloudSearchViewController.h"

@implementation SoundCloudSearchViewController

@synthesize masterViewController;
@synthesize mainView;
@synthesize mainSearchBar;
@synthesize soundCloudTableView;
@synthesize cancelSearch;

- (void)dealloc
{
    masterViewController = nil;
    [mainView release];
    [mainSearchBar release];
    [soundCloudTableView release];
    [super dealloc];
}

- (id)initWithMasterViewController:(UIViewController*)pC
{
    self = [super init];
    if (self) {
        self.masterViewController = pC;
        self.cancelSearch = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.mainView = [[[UIView alloc] init] autorelease];
    self.mainSearchBar = [[[UISearchBar alloc] init] autorelease];
    self.soundCloudTableView = [[[SoundCloudTableViewController alloc] initWithStyle:UITableViewStylePlain masterViewController:self.masterViewController] autorelease];
    
    if ([((iPad_MasterViewController*)self.masterViewController) lastRotation] == UIInterfaceOrientationLandscapeLeft) {
        [self.mainView setFrame:CGRectMake(0, 0, 320, 748)];
        [self.mainSearchBar setFrame:CGRectMake(0, 0, 320, 44)];
        [self.soundCloudTableView.view setFrame:CGRectMake(0, 44, 320, 704)];
    } else {
        [self.mainView setFrame:CGRectMake(0, 0, 320, 1004)];
        [self.mainSearchBar setFrame:CGRectMake(0, 0, 320, 44)];
        [self.soundCloudTableView.view setFrame:CGRectMake(0, 44, 320, 960)];
    }
    
    [self.mainSearchBar setShowsCancelButton:YES animated:NO];
    for (id subview in [self.mainSearchBar subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    [self.mainSearchBar setDelegate:self];
    [self.mainView addSubview:self.mainSearchBar];
    
    [self.mainView addSubview:self.soundCloudTableView.view];
    
    self.view = self.mainView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Search Bar lifecycle

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.cancelSearch = YES;
    [[NSOperationQueue mainQueue] cancelAllOperations];
    [[((iPad_DetailViewController*)[(iPad_MasterViewController*)self.masterViewController delegate]) popoverController] dismissPopoverAnimated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.cancelSearch = NO;
    
    //dismiss keyboard
    [searchBar resignFirstResponder];
    for (id subview in [searchBar subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }
    
    //display activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //construct http request for soundcloud
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    NSString *searchBarText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if (![searchBarText isEqualToString:@""]) {
        NSString *query = [NSString stringWithFormat:@"%@%@",@"http://soundcloud.com/search?q%5Bfulltext%5D=",searchBarText];
        NSLog(@"%@",query);
        NSURL *url = [NSURL URLWithString:query];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
            [NSURLConnection sendAsynchronousRequest:request queue:queue 
               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                   if (self.cancelSearch) { return; }
                   if (!error) {

                       [self parseData:data];
                   } else {
                       NSLog(@"invalid response: %@",error);
                   }
                   [self.soundCloudTableView.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
               }];
        } else {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURLResponse *synchronousResponse = nil;
                NSError *synchronousError = nil;
                if (self.cancelSearch) { return; }
                NSData *synchronousData = [NSURLConnection sendSynchronousRequest:request returningResponse:&synchronousResponse error:&synchronousError];
                if (!synchronousError) {
                    
                    [self parseData:synchronousData];
                } else {
                    NSLog(@"invalid response: %@",synchronousError);
                }
                
                [self.soundCloudTableView.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *emptyTerm = [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter a valid search term." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [emptyTerm show];
    }
}

- (void)parseData:(NSData*)data
{
    NSError *error = nil;
    NSString *parsed = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"%@",parsed);
    TBXML *tbxml = [[[TBXML alloc] initWithXMLString:parsed error:&error] autorelease];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root) {
        TBXMLElement *body = [TBXML childElementNamed:@"body" parentElement:root];
        TBXMLElement *main = [TBXML childElementNamed:@"div" parentElement:body];
        while (![[TBXML valueOfAttributeNamed:@"id" forElement:main] isEqualToString:@"main-wrapper"]) {
            main = [TBXML nextSiblingNamed:@"div" searchFromElement:main];
        }
        TBXMLElement *inner = [TBXML childElementNamed:@"div" parentElement:main];
        while (![[TBXML valueOfAttributeNamed:@"id" forElement:inner] isEqualToString:@"main-wrapper-inner"]) {
            inner = [TBXML nextSiblingNamed:@"div" searchFromElement:inner];
        }
        TBXMLElement *results = [TBXML childElementNamed:@"div" parentElement:inner];
        while (![[TBXML valueOfAttributeNamed:@"class" forElement:results] isEqualToString:@"results"]) {
            results = [TBXML nextSiblingNamed:@"div" searchFromElement:results];
        }
        if (results) {
            TBXMLElement *tracks = [TBXML childElementNamed:@"div" parentElement:results];
            while (![[TBXML valueOfAttributeNamed:@"id" forElement:tracks] isEqualToString:@"tracks"]) {
                tracks = [TBXML nextSiblingNamed:@"div" searchFromElement:tracks];
            }
            if (tracks) {
                TBXMLElement *trackslist = [TBXML childElementNamed:@"ul" parentElement:tracks];
                while (![[TBXML valueOfAttributeNamed:@"class" forElement:trackslist] isEqualToString:@"tracks-list"]) {
                    trackslist = [TBXML nextSiblingNamed:@"ul" searchFromElement:trackslist];
                }
                if (trackslist) {
                    //MAIN LOOP FOR TRACK INFORMATION
                    TBXMLElement *entry = [TBXML childElementNamed:@"li" parentElement:trackslist];
                    while (entry) {
                        NSString *tid = nil;
                        UIImage *thumbnail = nil;
                        NSString *title = nil;
                        NSString *artist = nil;
                        NSNumber *duration = 0;
                        if ([[TBXML valueOfAttributeNamed:@"class" forElement:entry] isEqualToString:@"player"]) {
                            //handle single track
                            NSLog(@"found a single track");
                            TBXMLElement *track = [TBXML childElementNamed:@"div" parentElement:entry];
                            if (track) {
                                tid = [TBXML valueOfAttributeNamed:@"data-sc-track" forElement:track];
                                //NSLog(@"ID: %@",tid);
                                TBXMLElement *info = [TBXML childElementNamed:@"div" parentElement:track];
                                if (info) {
                                    TBXMLElement *image = [TBXML childElementNamed:@"a" parentElement:info];
                                    NSString *thumbnailURL = nil;
                                    if (image) {
                                        //TODO: note this will show an error for the search "bottle neck"
                                        thumbnailURL = [TBXML valueOfAttributeNamed:@"href" forElement:image];
                                        thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailURL]]];
                                        CGImageRef imageRef = [thumbnail CGImage];
                                        CGContextRef contextRef = CGBitmapContextCreate(nil, 80, 60, CGImageGetBitsPerComponent(imageRef), 0, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
                                        CGContextDrawImage(contextRef, CGRectMake(0, 0, 80, 60), imageRef);
                                        CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
                                        thumbnail = [UIImage imageWithCGImage:newImageRef];
                                    } else {
                                        thumbnail = [UIImage imageNamed:@"SoundCloudNoArtwork"];
                                    }
                                    TBXMLElement *h = [TBXML childElementNamed:@"h3" parentElement:info];
                                    if (h) {
                                        TBXMLElement *name = [TBXML childElementNamed:@"a" parentElement:h];
                                        if (name) {
                                            title = [TBXML textForElement:name];
                                            NSLog(@"title: %@",title);
                                        }
                                    }
                                    TBXMLElement *subtitle = [TBXML childElementNamed:@"span" parentElement:info];
                                    if (subtitle) {
                                        TBXMLElement *user = [TBXML childElementNamed:@"span" parentElement:subtitle];
                                        if (user) {
                                            TBXMLElement *a = [TBXML childElementNamed:@"a" parentElement:user];
                                            if (a) {
                                                artist = [TBXML textForElement:a];
                                                NSLog(@"artist: %@",artist);
                                            }
                                        }
                                    }
                                }
                                TBXMLElement *actionBar = [TBXML nextSiblingNamed:@"div" searchFromElement:info];
                                if (actionBar) {
                                    TBXMLElement *container = [TBXML nextSiblingNamed:@"div" searchFromElement:actionBar];
                                    if (container) {
                                        TBXMLElement *controls = [TBXML childElementNamed:@"div" parentElement:container];
                                        if (controls) {
                                            TBXMLElement *timecodes = [TBXML childElementNamed:@"div" parentElement:controls];
                                            if (timecodes) {
                                                TBXMLElement *time = [TBXML childElementNamed:@"span" parentElement:timecodes];
                                                if (time) {
                                                    TBXMLElement *time2 = [TBXML nextSiblingNamed:@"span" searchFromElement:time];
                                                    if (time2) {
                                                        NSArray *split = [[TBXML textForElement:time2] componentsSeparatedByString:@"."];
                                                        duration = [NSNumber numberWithInt:[[split objectAtIndex:0] intValue]*60 + [[split objectAtIndex:1] intValue]];
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else if ([[TBXML valueOfAttributeNamed:@"class" forElement:entry] isEqualToString:@"set"]) {
                            //handle playlist
                            NSLog(@"found a playlist");
                        }
                        
                        if ( title && tid && artist && thumbnail && duration ) {
                            //TODO - need to add duration
                            NSArray *value = [NSArray arrayWithObjects:tid, artist, thumbnail, duration, nil];
                            [self.soundCloudTableView.searchResults setValue:value forKey:title];
                        }
                        
                        entry = [TBXML nextSiblingNamed:@"li" searchFromElement:entry];
                    }
                }
            }
        }
    } else {
        
        NSLog(@"%@",error);
    }
}

@end
