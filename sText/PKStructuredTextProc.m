//
//  PKStructuredTextProc.m
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextProc.h"

#import "PKStructuredTextOptionalNode.h"
#import "PKStructuredTextPickOneNode.h"
#import "PKStructuredTextPickAnyNode.h"
#import "PKStructuredTextNumberedNode.h"
#import "PKStructuredTextImportNode.h"

@implementation PKStructuredTextProc

- (PKStructuredTextNode *)nodeFromDictionary:(NSDictionary *)node {
    NSString *type = node[@"type"];
    PKStructuredTextNode *newNode;
    if ([type isEqualToString:@"optional"]) {
        newNode = [PKStructuredTextOptionalNode new];
    } else if ([type isEqualToString:@"pickOne"]) {
        newNode = [PKStructuredTextPickOneNode new];
    } else if ([type isEqualToString:@"pickAny"]) {
        newNode = [PKStructuredTextPickAnyNode new];
    } else if ([type isEqualToString:@"import"]) {
        newNode = [PKStructuredTextImportNode new];
    } else if ([type isEqualToString:@"numbered"]) {
        newNode = [PKStructuredTextNumberedNode new];
        if (node[@"numberPrefix"])
            ((PKStructuredTextNumberedNode *)newNode).numberPrefix = node[@"numberPrefix"];
        if (node[@"numberSuffix"])
            ((PKStructuredTextNumberedNode *)newNode).numberSuffix = node[@"numberSuffix"];
        //TODO::        @property (strong) NSNumber *numberType;
    } else {
        newNode = [PKStructuredTextNode new];
    }
    newNode.title = node[@"title"];
    newNode.nodeid = node[@"nodeid"];
    newNode.dataKeyPath = node[@"dataKeyPath"];
    newNode.valueKeyPath = node[@"valueKeyPath"];
    newNode.relativePath = node[@"relativePath"];
    newNode.value = node[@"value"];
    
    if (node[@"children"]) {
        for (NSDictionary *childNode in node[@"children"]) {
            PKStructuredTextNode *newChildNode = [self nodeFromDictionary:childNode];
            [newNode addChild:newChildNode];
        }
    }
    if (node[@"items"]) {
        for (NSDictionary *itemNode in node[@"items"]) {
            PKStructuredTextNode *newItemNode = [self nodeFromDictionary:itemNode];
            [newNode addItem:newItemNode];
        }
    }
    
    //TODO:: update value from values dict if valueKeyPath exisits...
    
    if (newNode.value && [newNode isKindOfClass:[PKStructuredTextPickAnyNode class]]) {
        for (id item in newNode.value) {
            PKStructuredTextNode *n;
            if ([item isKindOfClass:[NSNumber class]]) {
                NSUInteger val = [item unsignedIntegerValue];
                if (val >= newNode.items.count) {
                    continue;
                }
                n = newNode.items[val];
            } else if ([item isKindOfClass:[NSString class]]) {
                n = [newNode itemWithNodeId:item];
                if (n == nil) {
                    continue;
                }
            }
            [newNode addChild:[n copy]];
        }
    }
    if ([newNode isKindOfClass:[PKStructuredTextImportNode class]]) {
        NSString *path = [self.basePath stringByAppendingPathComponent:newNode.relativePath];
        NSArray *childArray = [self nodesFromURL:[NSURL fileURLWithPath:path]];
        if (childArray) {
            newNode.children = [NSMutableArray array];
            [newNode.children addObjectsFromArray:childArray];
            for (PKStructuredTextNode *n in newNode.children) {
                n.parent = newNode;
            }
        }
    }
    return newNode;
}

- (NSArray *)nodesFromURL:(NSURL *)url {
    NSMutableArray *ret;
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        ret = [NSMutableArray array];
        NSArray *nodes = [obj valueForKey:@"struct"];
        for (NSDictionary *node in nodes) {
            PKStructuredTextNode *newNode = [self nodeFromDictionary:node];
            [ret addObject:newNode];
        }
    }
    return ret;
}

- (NSString *)processRootNode:(PKStructuredTextNode *)rootNode {
    return [self processRootNodes:rootNode.children];
}

- (NSString *)processRootNodes:(NSArray *)rootNodes {
    NSMutableString *ret = [NSMutableString stringWithString:@""];
    for (PKStructuredTextNode *n in rootNodes) {
        NSString *r = [n outputWithDelegate:self andValues:self.values];
        if (r)
            [ret appendString:r];
    }
    return ret;
}

- (NSString *)outputOfNode:(PKStructuredTextNode *)node withTemplateAtPath:(NSString *)relativePath {
    NSString *path;
    if ([relativePath hasPrefix:self.libraryPrefix]) {
        path = [self.libraryPath stringByAppendingPathComponent:[relativePath substringFromIndex:1]];
    } else {
        path = [self.basePath stringByAppendingPathComponent:relativePath];
    }
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    if (error)
//        NSLog(@"%@", error);
    return contents;
}

@end
