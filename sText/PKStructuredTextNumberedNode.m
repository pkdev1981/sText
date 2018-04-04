//
//  PKStructuredTextNumberedNode.m
//  sText
//
//  Created by pkdev1981 on 02/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextNumberedNode.h"

@implementation PKStructuredTextNumberedNode

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values {
    NSString *prefix = @"";
    if (self.numberPrefix)
        prefix = self.numberPrefix;
    NSString *suffix = @"";
    if (self.numberSuffix)
        suffix = self.numberSuffix;
    __block NSUInteger i = 0;
    NSMutableString *ret = [NSMutableString stringWithString:@""];
    [self pickedWithValues:values actionBlock:^(PKStructuredTextNode *node) {
        NSString *nodeText = [node outputWithDelegate:delegate andValues:values];
        if (nodeText) {
            [ret appendFormat:@"%@%lu%@%@", prefix, i, suffix, nodeText];
            i++;
        }
    }];
    return ret;
}

@end
