//
//  RSSMasterViewController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSMasterViewController.h"

#import "RSSTitlesController.h"
#import "RSSService.h"
#import "Config.h"

@interface RSSMasterViewController () {
//    NSMutableArray *_rssURLS;
//    NSMutableArray *_rssTitles;
    RSSService *_rssService;
}
@end

@implementation RSSMasterViewController {
    UIAlertView *alert;
    UIActivityIndicatorView *activity;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Mobius RSS Reader", @"Master");
        _rssService = [[RSSService alloc] init];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [av startAnimating];

    self.navigationItem.rightBarButtonItem = addButton;
//    [self.navigationItem.titleView addSubview:av];



    //[self addFeed:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];

}

- (BOOL)addFeed:(NSString *)url {
    Config *cfg = [Config instance];
    NSMutableArray *items = cfg.items;
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSMutableDictionary *elem = [NSMutableDictionary new];
    [elem setObject:url forKey:@"url"];
    NSMutableDictionary *info = [NSMutableDictionary new];
    BOOL res = [_rssService feedInfoURL:nsUrl Info:info];
    if (!res) {
        return NO;
    }
    [elem setObject:[info valueForKey:@"title"] forKey:@"title"];
    [items insertObject:elem atIndex:0];
    [cfg write];
    return YES;
}

- (void)removeFeed:(NSUInteger)num {
    Config *cfg = [Config instance];
    [cfg.items removeObjectAtIndex:num];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    alert = [[UIAlertView alloc] initWithTitle:@"RSS Feed" message:@"Input rss feed" delegate:self                                          cancelButtonTitle:@"Done" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)text {
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview: activity];
    activity.center = CGPointMake(240,160);
    [activity startAnimating];
    if (![self addFeed:[[alert textFieldAtIndex:0] text]]) {
        [activity stopAnimating];
        [activity removeFromSuperview];

        alert = [[UIAlertView alloc] initWithTitle:@"RSS Feed" message:@"Cannot add rss feed" delegate:nil
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    [activity stopAnimating];
    [activity removeFromSuperview];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Config instance].items.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [av startAnimating];
//        cell.accessoryView = av;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [[Config instance].items[(NSUInteger) indexPath.row] valueForKey:@"title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFeed:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.rssTitlesController) {
        self.rssTitlesController = [[RSSTitlesController alloc] initWithNibName:@"RSSTitlesController" bundle:nil];
    }
    NSURL *url = [NSURL URLWithString:
    [[Config instance].items[(NSUInteger) indexPath.row] valueForKey:@"url"]];
    self.rssTitlesController.detailItem = url;
    [self.navigationController pushViewController:self.rssTitlesController animated:YES];

    [self.rssTitlesController reload];
}

@end