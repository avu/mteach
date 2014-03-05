//
//  RSSDetailViewController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()
- (void)configureView;

@property(nonatomic) IBOutlet UIWebView *webView;
@end

@implementation RSSDetailViewController
@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

- (void)reload {
    NSLog(@"%@", [item valueForKey:@"description"]);

    NSString *html = [NSString stringWithFormat:@"<html><body>%@<body></html>", [item valueForKey:@"description"]];

    [self.webView loadHTMLString:html baseURL:nil];

}
@end