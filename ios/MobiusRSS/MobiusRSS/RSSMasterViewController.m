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
    RSSService *_rssService;
}
@end

@implementation RSSMasterViewController {
    UIAlertView *alert;
    UIActivityIndicatorView *_activityIndicatorView;
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

    self.navigationItem.rightBarButtonItem = addButton;
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
}

- (void)insertNewObject:(id)sender
{

    alert = [[UIAlertView alloc] initWithTitle:@"RSS Feed" message:@"Input rss feed" delegate:self                                          cancelButtonTitle:@"Done" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)text {

    [alert dismissWithClickedButtonIndex:0 animated:NO];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize size = self.view.superview.frame.size;
    _activityIndicatorView.center = CGPointMake(size.width/2.0, size.height/2.0);
    [self.view.superview addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    if (![self addFeed:[[alert textFieldAtIndex:0] text]]) {
        alert = [[UIAlertView alloc] initWithTitle:@"RSS Feed" message:@"Cannot add rss feed" delegate:nil
                                 cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        [_activityIndicatorView removeFromSuperview];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_activityIndicatorView removeFromSuperview];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [[Config instance].items[(NSUInteger) indexPath.row] valueForKey:@"title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFeed:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    [activityIndicatorView startAnimating];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = activityIndicatorView;

    dispatch_queue_t loadQueue = dispatch_queue_create("Load Queue",NULL);

    dispatch_async(loadQueue, ^{
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        [self.rssTitlesController reload];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:self.rssTitlesController animated:YES];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        });

    });
}

@end