//
//  RSSDetailViewController.h
//  MobiusRSS
//
//  Created by Alexey Ushakov on 2/28/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property NSDictionary *item;

- (void)reload;
@end