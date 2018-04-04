//
//  PKStructuredTextNumberedNode.h
//  sText
//
//  Created by pkdev1981 on 02/04/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextPickAnyNode.h"

@interface PKStructuredTextNumberedNode : PKStructuredTextPickAnyNode

@property (strong) NSString *numberPrefix;
@property (strong) NSString *numberSuffix;
@property (strong) NSNumber *numberType;

@end
