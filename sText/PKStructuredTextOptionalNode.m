//
//  PKStructuredTextOptionalNode.m
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextOptionalNode.h"

@implementation PKStructuredTextOptionalNode

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values {
    BOOL val = NO;
    if (values) {
        NSString *vKeyPath = [self nodeValueKeyPath];
        if (vKeyPath) {
            id v = [values valueForKeyPath:vKeyPath];
            if (v)
                val = [v boolValue];
        }
    } else if (self.value) {
        val = [self.value boolValue];
    }
    if (val)
        return [super outputWithDelegate:delegate andValues:values];
    return nil;
}

@end
