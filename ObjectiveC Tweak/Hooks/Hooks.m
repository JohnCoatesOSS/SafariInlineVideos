//
//  Hooks
//  Safari Inline Videos
//
//  Created by John Coates on 4/28/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Monolith/Monolith.h>
#import <MobileSubstrateStubs/MobileSubstrateStubs.h>

/* 
	These hooks are all jumbled in here, probably not the best example!
 
*/

@interface SIV_UIWebView : MONHook

@end
@implementation SIV_UIWebView

+ (NSString *)targetClass {
    return @"UIWebView";
}

- (BOOL)allowsInlineMediaPlayback_hook:(MONCallHandler *)call {
	return YES;
}

@end

@interface SIV_UIWebBrowserView : MONHook

@end
@implementation SIV_UIWebBrowserView

+ (NSString *)targetClass {
	return @"UIWebBrowserView";
}

- (BOOL)allowsInlineMediaPlayback_hook:(MONCallHandler *)call {
	return YES;
}

@end


@interface SIV_UIWebViewSettings : MONHook

@end
@implementation SIV_UIWebViewSettings

+ (NSString *)targetClass {
	return @"_UIWebViewSettings";
}

- (BOOL)allowsInlineMediaPlayback_hook:(MONCallHandler *)call {
	return YES;
}

@end


@interface SIV_WKWebViewConfiguration : MONHook

@end
@implementation SIV_WKWebViewConfiguration

+ (NSString *)targetClass {
	return @"WKWebViewConfiguration";
}

- (BOOL)allowsInlineMediaPlayback_hook:(MONCallHandler *)call {
	return YES;
}

@end


@interface SIV_FigPluginView : MONHook
@end

@implementation SIV_FigPluginView

+ (NSString *)targetClass {
	return @"FigPluginView";
}
- (void)willBeginPlayback_hook:(MONCallHandler *)call {
	[self mediaElementAttributeChanged:@"webkit-playsinline" value:@(TRUE)];
	[call callOriginalMethod];
}

// stub
-(void)mediaElementAttributeChanged:(id)changed value:(id)value {
}

@end


@interface SIV_DOMElement : MONHook {
	
}
@end

static int (*original_getAttribute)(void *instance, int *string, int * unknown);
static int getAttribute(void *instance, int *string, int * unknown);

@implementation SIV_DOMElement

+ (NSString *)targetClass {
	return @"DOMElement";
}

- (id)firstElementChild_hook:(MONCallHandler *)call {
	// This is a bit hacky
	// I'm hooking a random WebCore class to get notified of WebCore's load through +(void)installedHooks
	return [call callOriginalMethod];
}

+ (void)installedHooks {
	// We need to use Substrate for this as Monolith doesn't support
	// hooking C++ methods
	void *func;
	func = MSFindSymbol(NULL, "__ZNK7WebCore7Element12getAttributeERKNS_13QualifiedNameE");
	if (func) {
		MSHookFunction((int *)func, (int*)getAttribute, (void**)&original_getAttribute);
	}
}

@end

@interface DOMElement : NSObject
- (NSString *)nodeName;
- (void)setAttribute:(id)attribute value:(id)value;

@end

#import <malloc/malloc.h>
#import <mach/mach.h>
#import <objc/runtime.h>
#include <dlfcn.h>

int offsetForInstanceVariable(void *object, NSString *instanceVariableName) {
	Class class = object_getClass((__bridge id)object);
	
	while (class && class != [NSObject class]) {
		unsigned count, i;
		Ivar* firstIvar = class_copyIvarList(class, &count);
		
		const char *instanceVariableNameCString = instanceVariableName.UTF8String;
		
		for (i = 0; i < count; i++)	{
			Ivar* ivar = firstIvar + i;
			const char *nameCString = ivar_getName(*ivar);
			
			if (strcmp(instanceVariableNameCString, nameCString) == 0) {
				return (int)ivar_getOffset(*ivar);
			}
		}
		
		free(firstIvar);
		
		class = class_getSuperclass(class);
	}
	
		NSLog(@"couldn't find %@ in %@", instanceVariableName, NSStringFromClass(class));
	
	return -1;
}


id const createClassInstance(Class const class);

static int getAttribute(void *instance, int *string, int * unknown) {
	int ret = original_getAttribute(instance, string, unknown);
	
	
	static DOMElement *testElement;
	static CFMutableSetRef checked;
	if (!testElement) {
		testElement = createClassInstance([DOMElement class]);
		checked = CFSetCreateMutable(NULL, 0, NULL);
	}
	
	if (CFSetContainsValue(checked, instance)){
		return ret;
	}
	
	static int internalOffset = -2;
	if (internalOffset == -2) {
		internalOffset = offsetForInstanceVariable((__bridge void *)testElement, @"_internal");
	}
	
	if (internalOffset != -2 && internalOffset != -1) {
		void *internalAddress = (__bridge void *)testElement;
		internalAddress += internalOffset;
		memcpy(internalAddress, &instance, sizeof(instance));
		
		if ([[testElement nodeName].lowercaseString isEqualToString:@"video"]) {
			[testElement setAttribute:@"webkit-playsinline" value:@"webkit-playsinclassline"];
		}
	}
	
	CFSetAddValue(checked, instance);
	
	return ret;
}


