//
//  ViewController.m
//  hookTarget
//
//  Created by John Coates on 6/1/15.
//  Copyright (c) 2015 John Coates. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface MONOperative : NSObject
+ (BOOL)logAllMethodsForClass:(Class)class;
+ (BOOL)logAllMethodsForImage:(NSString *)imageName;
@end

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
	}
	
	return self;
}

- (void)viewDidLoad {
	[UIView setAnimationsEnabled:FALSE];
	
	[super viewDidLoad];
	
//	WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:webView];

	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.imgur.com/OZz4qTS.gifv"]]];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
