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
#import "TitleTableCell.h"

@interface RSSTitlesController () {
    NSMutableArray *feeds;
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
    feeds = [[NSMutableArray alloc] init];
    [rss newsURL:self.detailItem News:feeds];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TitleTableCell";
    static NSString *CellNib = @"TitleTableCell";

    TitleTableCell *cell = (TitleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (TitleTableCell *)[nib objectAtIndex:0];
    }

    cell.title.text =  [[feeds objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"title"];
    cell.title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.title.numberOfLines = 0;

// "pubDate" -> "11 Mar 2014 00:02:22 +0400"
// "pubDate" -> "Wed, 12 Feb 2014 23:30:00 +0400"
    NSArray *formats = @[@"dd MMM yyyy HH:mm:ss Z", @"EEE, dd MMM yyyy HH:mm:ss Z"];

    NSString *strDate = [[feeds objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"pubDate"];
    strDate = [strDate componentsSeparatedByString:@"\n"][0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = nil;
    for (NSString *f in formats) {
        [formatter setDateFormat:f];
        date = [formatter dateFromString:strDate];
        if (date) break;
    }

    if (date) {
        [formatter setDateFormat:@"HH:mm dd.MM.yyyy "];
        cell.date.text = [formatter stringFromDate:date];
    }
    cell.date.lineBreakMode = NSLineBreakByWordWrapping;
    cell.date.numberOfLines = 0;


    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rssDetailController) {
        self.rssDetailController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetailViewController"
                                                                             bundle:nil];
    }
    NSDictionary *object = [feeds objectAtIndex:(NSUInteger) indexPath.row];
    self.rssDetailController.item = [object copy];
    [self.navigationController pushViewController:self.rssDetailController animated:YES];
}
@end
