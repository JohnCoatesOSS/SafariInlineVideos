//
//  MONPluginSafariInlineVideos.m
//  Safari Inline Videos
//
//  Created by John Coates on 6/6/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <Monolith/Monolith.h>
#import "MONPluginSafariInlineVideos.h"

@implementation MONPluginSafariInlineVideos

+ (NSString *)name {
	return @"Safari Inline Videos";
}

+ (BOOL)shouldLoadIntoProcess:(MONProcess *)process {
	if (!process.bundleIdentifier) {
		return FALSE;
	}
	
	NSArray *validBundles = @[@"com.apple.WebKit.WebContent", @"com.apple.mobilesafari"];
	
	return [validBundles containsObject:process.bundleIdentifier];
}

@end
