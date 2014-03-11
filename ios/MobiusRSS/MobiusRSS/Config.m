//
// Created by Alexey Ushakov on 3/9/14.
// Copyright (c) 2014 jetbrains. All rights reserved.
//

#import "Config.h"
#import "PListService.h"


@implementation Config {
    NSString *_configPath;
    NSMutableDictionary *_values;

}

+ (Config *)instance {
    static Config *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithConfigPath:@"Config"];
        }
    }

    return _instance;
}

- (instancetype)initWithConfigPath:(NSString *)configPath {
    self = [super init];
    if (self) {
        _configPath = configPath;
        [self load];
    }

    return self;
}

- (NSMutableArray *)items {
    return [_values valueForKey:@"items"];
}

- (void)write {
    NSString *path = [[NSBundle mainBundle] pathForResource:_configPath ofType:@"plist"];

    [PListService writePlist:_values fileName:path];
}

- (void)load {
    NSString *path = [[NSBundle mainBundle] pathForResource:_configPath ofType:@"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        _values = [PListService readPlist:path];
        if (_values) return;
    }
    _values = [NSMutableDictionary dictionary];
    [_values setObject:[NSMutableArray new] forKey:@"items"];
}

@end