//
// Created by Alexey Ushakov on 1/27/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "WebServiceDelegate.h"


@implementation WebServiceDelegate {

}

@synthesize receivedData;

@synthesize requestStarted;

@synthesize requestCompleted;

@synthesize requestFailed;

- (id)init
{
    self = [super init];
    if (self) {
        receivedData = [[NSMutableData alloc] init];
        requestCompleted = NO;
        requestFailed = NO;
        requestStarted = NO;

    }

    return self;
}

- (void)connection:(NSURLConnection *)c didReceiveResponse:(NSURLResponse *)r {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)c didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)c {
    requestCompleted = YES;
}

- (void)connection:(NSURLConnection *)c didFailWithError:(NSError *)error {
    requestFailed = YES;
}

- (BOOL)connection:(NSURLConnection *)c canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)ps {
    return [ps.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)c didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)ch {
    if ([ch.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //    if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [ch.sender useCredential    : [NSURLCredential credentialForTrust:ch.protectionSpace.serverTrust]
      forAuthenticationChallenge:ch];
    }

    [ch.sender continueWithoutCredentialForAuthenticationChallenge:ch];
}

- (void)reset {
    requestCompleted = NO;
    requestFailed = NO;
    requestStarted = NO;
    [receivedData setLength:0];
}

@end