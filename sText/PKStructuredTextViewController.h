//
//  PKStructuredTextViewController.h
//  sText
//
//  Created by pkdev1981 on 30/03/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PKStructuredTextProc.h"

@interface PKStructuredTextViewController : NSViewController

- (instancetype)initWithURL:(NSURL *)url;
@property (strong) NSMutableArray *rootNodes;

@property (strong) PKStructuredTextProc *proc;

@end
