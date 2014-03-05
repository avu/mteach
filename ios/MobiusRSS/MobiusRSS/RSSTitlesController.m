//
//  RSSTitlesController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSTitlesController.h"
#import "RSSDetailViewController.h"
#import "RSSService.h"

@interface RSSTitlesController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSString *element;
    RSSService *rss;
}

@end

@implementation RSSTitlesController
@synthesize detailItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Titles", @"Titles");
        rss = [[RSSService alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)reload {
    NSURL *url = self.detailItem;
    feeds = [[NSMutableArray alloc] init];
    [rss newsURL:url News:feeds];
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rssDetailController) {
        self.rssDetailController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetailViewController" bundle:nil];
    }
    NSString *object = [feeds objectAtIndex:indexPath.row];
    self.rssDetailController.item = [ object copy];
    [self.navigationController pushViewController:self.rssDetailController animated:YES];
    [self.rssDetailController reload];

}
@end
