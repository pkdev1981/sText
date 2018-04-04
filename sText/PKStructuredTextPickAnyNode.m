//
//  PKStructuredTextPickAnyNode.m
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextPickAnyNode.h"

@implementation PKStructuredTextPickAnyNode

- (void)pickedWithValues:(NSDictionary *)values actionBlock:(void (^)(PKStructuredTextNode *))block {
    NSArray *valArray;
    if (values) {
        NSString *vKeyPath = [self nodeValueKeyPath];
        if (vKeyPath) {
            id v = [values valueForKeyPath:vKeyPath];
            if (v && [v isKindOfClass:[NSArray class]]) {
                valArray = v;
            }
        }
    } else if (self.value) {
        valArray = self.value;
    }
    if (valArray == nil || valArray.count == 0) {
        return;
    }
    NSUInteger i = 0;
    for (id item in valArray) {
        PKStructuredTextNode *n;
        if ([item isKindOfClass:[NSNumber class]]) {
            NSUInteger val = [item unsignedIntegerValue];
            if (val >= self.items.count) {
                continue;
            }
            n = self.items[val];
        } else if ([item isKindOfClass:[NSString class]]) {
            n = [self itemWithNodeId:item];
            if (n == nil) {
                continue;
            }
        }
        //TODO::
        if (self.children.count > i) {
            PKStructuredTextNode *nv = self.children[i];
            i++;
            n.value = nv.value;
        }
        block(n);
    }
}

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values {
    NSMutableString *ret = [NSMutableString stringWithString:@""];
    [self pickedWithValues:values actionBlock:^(PKStructuredTextNode *node) {
        NSString *r = [node outputWithDelegate:delegate andValues:values];
        if (r) {
            [ret appendString:r];
        }
    }];
    return ret;
}

@end
