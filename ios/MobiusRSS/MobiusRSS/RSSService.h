//
// Created by Alexey Ushakov on 3/5/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSSService : NSObject {
}

-(BOOL)feedInfoURL:(NSURL *)url Info:(NSMutableDictionary *)dictionary;
-(BOOL)newsURL:(NSURL *)url News:(NSMutableDictionary *)dictionary;

@end