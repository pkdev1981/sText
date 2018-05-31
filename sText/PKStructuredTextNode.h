//
//  PKStructuredTextNode.h
//  sText
//
//  Created by pkdev1981 on 30/03/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKStructuredTextNodeDelegate;

@interface PKStructuredTextNode : NSObject

@property (strong) NSString *title;
@property (strong) NSMutableArray *children;
@property (weak) PKStructuredTextNode *parent;
@property (readonly) BOOL isLeaf;

@property (strong) NSString *relativePath;
@property (strong) NSString *dataKeyPath;
@property (strong) NSString *valueKeyPath;

@property (strong) NSString *nodeid;

- (NSString *)outputWithDelegate:(id <PKStructuredTextNodeDelegate>)delegate andValues:(NSDictionary *)values;

- (NSString *)nodeDataKeyPath;
- (NSString *)nodeValueKeyPath;
- (void)addChild:(PKStructuredTextNode *)childNode;

@property (strong) NSMutableArray *items;
- (void)addItem:(PKStructuredTextNode *)itemNode;

@property (strong) id value;

- (NSArray *)itemTitles;
- (PKStructuredTextNode *)itemWithNodeId:(NSString *)nodeid;

- (void)depthFirst:(void (^)(PKStructuredTextNode *))block;

- (NSString *)templateString;
- (NSString *)lastProcessedString;
- (NSString *)userEditedString;

@end

@protocol PKStructuredTextNodeDelegate <NSObject>
@required
- (NSString *)outputOfNode:(PKStructuredTextNode *)node withTemplateAtPath:(NSString *)relativePath;
@end
