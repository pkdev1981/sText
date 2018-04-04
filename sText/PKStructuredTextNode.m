//
//  PKStructuredTextNode.m
//  sText
//
//  Created by pkdev1981 on 30/03/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextNode.h"

@implementation PKStructuredTextNode

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)isLeaf {
    if (self.children == nil)
        return YES;
    if (self.children.count == 0)
        return YES;
    return NO;
}

- (void)addChild:(PKStructuredTextNode *)childNode {
    [self willChangeValueForKey:@"children"];
    if (self.children == nil)
        self.children = [NSMutableArray array];
    [self.children addObject:childNode];
    childNode.parent = self;
    [self didChangeValueForKey:@"children"];
}

- (void)addItem:(PKStructuredTextNode *)itemNode {
    if (self.items == nil)
        self.items = [NSMutableArray array];
    [self.items addObject:itemNode];
}

- (NSString *)nodeDataKeyPath {
    if (self.dataKeyPath == nil)
        return nil;
    return self.dataKeyPath;
}

- (NSString *)nodeValueKeyPath {
    if (self.valueKeyPath == nil)
        return nil;
    return self.valueKeyPath;
}

- (NSArray *)itemTitles {
    NSMutableArray *ret = [NSMutableArray array];
    for (PKStructuredTextNode *n in self.items)
        [ret addObject:[n.title copy]];
    return ret;
}

- (PKStructuredTextNode *)itemWithNodeId:(NSString *)nodeid {
    for (PKStructuredTextNode *n in self.items) {
        if ([n.nodeid isEqualToString:nodeid]) {
            return n;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    PKStructuredTextNode *ret = [[[self class] allocWithZone:zone] init];
    ret.title = self.title;
    ret.children = [[NSMutableArray alloc] initWithArray:self.children copyItems:YES];
    for (PKStructuredTextNode *n in ret.children)
        n.parent = ret;
    ret.items = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
    ret.relativePath = self.relativePath;
    ret.dataKeyPath = self.dataKeyPath;
    ret.valueKeyPath = self.valueKeyPath;
    ret.value = [self.value copy];
    ret.nodeid = self.nodeid;
    return ret;
}

- (void)depthFirst:(void (^)(PKStructuredTextNode *))block {
    for (PKStructuredTextNode *node in self.children)
        [node depthFirst:block];
    return block(self);
}

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values {
    if (self.children) {
        NSMutableString *ret = [NSMutableString stringWithString:@""];
        for (PKStructuredTextNode *n in self.children) {
            NSString *r = [n outputWithDelegate:delegate andValues:values];
            if (r)
                [ret appendString:r];
        }
        return ret;
    }
    return [delegate outputOfNode:self withTemplateAtPath:self.relativePath];
}

@end
