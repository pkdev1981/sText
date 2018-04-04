//
//  PKStructuredTextProc.h
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKStructuredTextNode.h"

@interface PKStructuredTextProc : NSObject <PKStructuredTextNodeDelegate>

@property (strong) NSString *basePath;
@property (strong) NSString *libraryPath;
@property (strong) NSString *libraryPrefix;

@property (strong) NSMutableDictionary *data;
@property (strong) NSMutableDictionary *values;

- (NSString *)processRootNode:(PKStructuredTextNode *)rootNode;
- (NSString *)processRootNodes:(NSArray *)rootNodes;

- (NSArray *)nodesFromURL:(NSURL *)url;

@end
