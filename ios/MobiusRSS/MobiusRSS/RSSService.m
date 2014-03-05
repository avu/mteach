//
// Created by Alexey Ushakov on 3/5/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "RSSService.h"


@implementation RSSService {

    NSString *element;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *description;
    NSMutableString *link;
    NSMutableArray *feeds;
    NSMutableString *date;
    BOOL parseComplete;
    BOOL parseFailed;
    NSMutableDictionary *info;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    element = elementName;

    if (feeds) {
        if ([element isEqualToString:@"item"]) {
            item = [[NSMutableDictionary alloc] init];
            title = [[NSMutableString alloc] init];
            link = [[NSMutableString alloc] init];
            description = [[NSMutableString alloc] init];
            date = [[NSMutableString alloc] init];
        }
    }
    else if (info) {
        if ([element isEqualToString:@"channel"]) {
            title = [[NSMutableString alloc] init];
            description = [[NSMutableString alloc] init];
            link = [[NSMutableString alloc] init];
        }
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!parseComplete) {
        if ([element isEqualToString:@"title"]) {
            [title appendString:string];
        } else if ([element isEqualToString:@"link"]) {
            [link appendString:string];
        } else if ([element isEqualToString:@"description"]) {
            [description appendString:string];
        } else if ([element isEqualToString:@"pubDate"]) {
            [date appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (feeds) {
        if ([elementName isEqualToString:@"item"]) {

            [item setObject:title forKey:@"title"];
            [item setObject:link forKey:@"link"];
            [item setObject:description forKey:@"description"];
            [item setObject:date forKey:@"pubDate"];
            [feeds addObject:[item copy]];

        }
    }
    else if (info) {
        [info setObject:title forKey:@"title"];
        [info setObject:link forKey:@"link"];
        [info setObject:description forKey:@"description"];
        parseComplete = YES;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    parseComplete = YES;
}


- (BOOL)feedInfoURL:(NSURL *)url Info:(NSMutableDictionary *)dictionary {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    info = dictionary;
    feeds = nil;
    parseComplete = NO;
    parseFailed = NO;
    [parser parse];
    while (!parseComplete && !parseFailed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    return parseComplete;
}

- (BOOL)newsURL:(NSURL *)url News:(NSMutableDictionary *)dictionary {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    info = nil;
    feeds = dictionary;
    parseComplete = NO;
    parseFailed = NO;
    [parser performSelectorInBackground:@selector(parse) withObject:nil];
    while (!parseComplete && !parseFailed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    return parseComplete;
}


@end