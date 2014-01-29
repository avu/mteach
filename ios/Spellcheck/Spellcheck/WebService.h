//
// Created by Alexey Ushakov on 1/27/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebService : NSObject

+ (BOOL)validateText:(NSString *)text result:(NSObject **)receivedInfo error:(NSError **)error;
@end