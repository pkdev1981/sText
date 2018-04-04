//
//  PKStructuredTextPickOneNode.m
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextPickOneNode.h"

@implementation PKStructuredTextPickOneNode

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values {
    NSUInteger val = 0;
    if (values) {
        NSString *vKeyPath = [self nodeValueKeyPath];
        if (vKeyPath) {
            id v = [values valueForKeyPath:vKeyPath];
            if (v)
                val = [v unsignedIntegerValue];
        }
    } else if (self.value) {
        val = [self.value unsignedIntegerValue];
    }
    if (val >= self.items.count)
        return nil;
    PKStructuredTextNode *n = self.items[val];
    return [n outputWithDelegate:delegate andValues:values];
}

@end
