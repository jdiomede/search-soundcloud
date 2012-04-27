//  Created by James Diomede on 11/15/11.
//  Copyright (c) 2011 Diomede, Inc. All rights reserved.
//

#ifndef SoundOnSound_Defines_h
#define SoundOnSound_Defines_h

//Define SoundCloud search results indices
static int const SOUNDCLOUD_TID = 0;
static int const SOUNDCLOUD_ARTIST = 1;
static int const SOUNDCLOUD_THUMBNAIL = 2;
static int const SOUNDCLOUD_DURATION = 3;

// System Versioning Preprocessor Macros 
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
