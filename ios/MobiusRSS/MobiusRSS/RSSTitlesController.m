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
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    cell.textLabel.font = [UIFont systemFontOfSize:10];
//    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
//
//    cell.textLabel.text =[NSString stringWithFormat:@"%@ %@", [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"],
//    [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"]];
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.numberOfLines = 0;
//
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TitleTableCell";
    static NSString *CellNib = @"TitleTableCell";

    TitleTableCell *cell = (TitleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (TitleTableCell *)[nib objectAtIndex:0];
    }

    cell.title.text =  [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.title.lineBreakMode = NSLineBreakByWordWrapping;
    cell.title.numberOfLines = 0;

// "pubDate" -> "11 Mar 2014 00:02:22 +0400
    NSString *strDate = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    strDate = [strDate componentsSeparatedByString:@"\n"][0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss Z"];

    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    NSDate *dateFromStr = [formatter dateFromString:strDate];
    [formatter setDateFormat:@"HH:mm:ss dd.mm.yyyy "];
//    cell.date.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    cell.date.text = [formatter stringFromDate:dateFromStr];
    cell.date.lineBreakMode = NSLineBreakByWordWrapping;
    cell.date.numberOfLines = 0;


    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle;
    if (!self.rssDetailController) {
        self.rssDetailController = [[RSSDetailViewController alloc] initWithNibName:@"RSSDetailViewController" bundle:nil];
    }
    NSString *object = [feeds objectAtIndex:indexPath.row];
    self.rssDetailController.item = [ object copy];
    [self.navigationController pushViewController:self.rssDetailController animated:YES];
}
@end
