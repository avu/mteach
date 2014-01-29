//
// Created by Alexey Ushakov on 1/27/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceDelegate : NSObject {
    NSMutableData* receivedData;
    BOOL requestStarted;
    BOOL requestCompleted;
    BOOL requestFailed;
}

@property (readonly) NSMutableData* receivedData;
@property BOOL requestStarted;
@property BOOL requestCompleted;
@property BOOL requestFailed;

- (void)connection:(NSURLConnection *)c didReceiveResponse:(NSURLResponse *)r;
- (void)connection:(NSURLConnection *)c didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)c;
- (void)connection:(NSURLConnection *)c didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)c
        canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)ps;
- (void)connection:(NSURLConnection *)c
        didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)ch;

-(void)reset;

@end