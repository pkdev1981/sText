//
//  PKStructuredTextPickAnyNode.h
//  sText
//
//  Created by pkdev1981 on 01/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextNode.h"

@interface PKStructuredTextPickAnyNode : PKStructuredTextNode

@property (strong) NSNumber *valueToAdd;

- (void)pickedWithValues:(NSDictionary *)values actionBlock:(void (^)(PKStructuredTextNode *))block;

@end
