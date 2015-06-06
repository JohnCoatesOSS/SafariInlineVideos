//
//  classCreate.m
//  ObjectiveC Tweak
//
//  Created by John Coates on 6/5/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <stdlib.h>

id createClassInstance(Class const class) {
	id instance = class_createInstance(class, 0);
	[instance retain];
	return  instance;
}