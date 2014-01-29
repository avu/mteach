//
//  SpellViewController.m
//  Spellcheck
//
//  Created by Alexey Ushakov on 1/27/14.
//  Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "SpellViewController.h"
#import "WebService.h"

@interface SpellViewController ()

@end

@implementation SpellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    NSString *str = [NSString stringWithFormat:@"file://%@",
                    [[NSBundle mainBundle] pathForResource:@"ui" ofType:@"html"]];
    NSString *url = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    webView.delegate = self;
    [webView loadRequest:request];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                                 navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL scheme] isEqual:@"spellchecker"]) {
        NSString *txt = [webView stringByEvaluatingJavaScriptFromString:
                @"document.getElementById(\"input\").value"];

        NSError *err = nil;
        NSArray *res = nil;
        if (![WebService validateText:txt result:&res error:&err]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Cannot use web service"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else {
            if (res.count == 0) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"No spell errors found"
                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                NSMutableString *str = [NSMutableString new];
                for (NSDictionary *d in res) {
                    NSLog(@"%@", d);
//                    [str appendString:[d valueForKey:<#(NSString *)key#>]];
                }
                [webView stringByEvaluatingJavaScriptFromString:
                        [NSString stringWithFormat:@"showText(\"%@\")", @"eeeeee"]];


//                [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Found %d spell errors", res.count]
//                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }

        }

        return NO;
    }

    return YES;
}

@end