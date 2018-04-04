//
//  PKStructuredTextViewController.m
//  sText
//
//  Created by pkdev1981 on 30/03/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "PKStructuredTextViewController.h"
#import "PKStructuredTextNode.h"
#import "PKStructuredTextOptionalNode.h"
#import "PKStructuredTextPickOneNode.h"
#import "PKStructuredTextPickAnyNode.h"
//#import "PKStructuredTextNumberedNode.h"
//#import "PKStructuredTextImportNode.h"

#import "PKStructuredTextProc.h"

@interface PKStructuredTextViewController () <NSOutlineViewDelegate>

@property (strong) NSURL *fileURL;
@property (strong) PKStructuredTextProc *proc;

@end

@implementation PKStructuredTextViewController

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.fileURL = url;
        self.proc = [PKStructuredTextProc new];
        self.proc.libraryPrefix = @"$";
        self.proc.libraryPath = [@"~/Desktop/dev/Cntrcts/ContractsAppData" stringByExpandingTildeInPath];
        self.proc.basePath = [[self.fileURL path] stringByDeletingLastPathComponent];

        NSArray *childArray = [self.proc nodesFromURL:url];
        if (childArray) {
            self.rootNodes = [NSMutableArray array];
            [self.rootNodes addObjectsFromArray:childArray];
        }
    }
    return self;
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    NSView *cellView;
    PKStructuredTextNode *node = [item representedObject];
    if ([node isKindOfClass:[PKStructuredTextOptionalNode class]])
        cellView = [outlineView makeViewWithIdentifier:@"optional" owner:self];
    else if ([node isKindOfClass:[PKStructuredTextPickOneNode class]])
        cellView = [outlineView makeViewWithIdentifier:@"pickOne" owner:self];
    else if ([node isKindOfClass:[PKStructuredTextPickAnyNode class]])
        cellView = [outlineView makeViewWithIdentifier:@"pickAny" owner:self];
    else
        cellView = [outlineView makeViewWithIdentifier:@"plain" owner:self];
    return cellView;
}

- (IBAction)addPickAnyItem:(id)sender {
    NSTableRowView *r = (NSTableRowView *)[[sender superview] superview];
    NSOutlineView *outlineView = (NSOutlineView *)r.superview;
    PKStructuredTextPickAnyNode *pickAnyNode = [[outlineView itemAtRow:[outlineView rowForView:sender]] representedObject];
    NSLog(@"%@", pickAnyNode.valueToAdd);
    NSUInteger val = 0;
    if (pickAnyNode.valueToAdd != nil)
        val = [pickAnyNode.valueToAdd unsignedIntegerValue];
    PKStructuredTextNode *n = [pickAnyNode.items[val] copy];
    [pickAnyNode addChild:n];
    if (pickAnyNode.value == nil)
        pickAnyNode.value = [NSMutableArray array];
    [pickAnyNode.value addObject:[NSNumber numberWithUnsignedInteger:val]];
    [outlineView expandItem:nil expandChildren:YES];
}

- (NSDictionary *)currentValues {
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    for (PKStructuredTextNode *n in self.rootNodes) {
        [n depthFirst:^(PKStructuredTextNode *node) {
            if (node.nodeValueKeyPath && node.value) {
                [ret setValue:node.value forKeyPath:node.nodeValueKeyPath];
            }
        }];
    }
    return ret;
}

- (IBAction)build:(id)sender {
    NSLog(@"%@", [self currentValues]);
    NSString *ret = [self.proc processRootNodes:self.rootNodes];
    NSLog(@"build: [%@]", ret);
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do view setup here.
//}

@end
