//
//  MONPluginSafariInlineVideos.h
//  Safari Inline Videos
//
//  Created by John Coates on 6/6/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MONPluginSafariInlineVideos : MONPlugin

+ (NSString *)name;

+ (BOOL)shouldLoadIntoProcess:(MONProcess *)process;

@end
