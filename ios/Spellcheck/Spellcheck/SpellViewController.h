//
//  SpellViewController.h
//  Spellcheck
//
//  Created by Alexey Ushakov on 1/27/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceDelegate.h"

@interface SpellViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
}


- (BOOL)validateText:(NSString *)text;


@end