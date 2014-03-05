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
    self.myOutput.text = [item valueForKey:@"description"];
}
@end