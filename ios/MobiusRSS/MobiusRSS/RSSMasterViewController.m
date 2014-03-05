//
//  RSSMasterViewController.m
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSMasterViewController.h"

#import "RSSDetailViewController.h"
#import "RSSTitlesController.h"
#import "RSSService.h"
#import "Notify.h"

@interface RSSMasterViewController () {
    NSMutableArray *_rssURLS;
    NSMutableArray *_rssTitles;
    RSSService *_rssService;
}
@end

@implementation RSSMasterViewController {
    UIAlertView *alert;
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

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self addFeed:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];

}

- (void)addFeed:(NSString *)url {
    if (!_rssURLS) {
        _rssURLS = [[NSMutableArray alloc] init];
        _rssTitles = [[NSMutableArray alloc] init];
    }
    [_rssURLS insertObject:[NSURL URLWithString:url] atIndex:0];
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [_rssService feedInfoURL:[_rssURLS objectAtIndex:0] Info:info];
    [_rssTitles insertObject:[info valueForKey:@"title"] atIndex:0];
}

- (void)removeFeed:(NSUInteger)num {
    [_rssURLS removeObjectAtIndex:num];
    [_rssTitles removeObjectAtIndex:num];
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
    [self addFeed:[[alert textFieldAtIndex:0] text]];
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
    return _rssURLS.count;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = _rssTitles[indexPath.row];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFeed:indexPath.row];
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
    NSString *object = _rssURLS[indexPath.row];
    self.rssTitlesController.detailItem = object;
    [self.navigationController pushViewController:self.rssTitlesController animated:YES];
    [self.rssTitlesController reload];
}

@end