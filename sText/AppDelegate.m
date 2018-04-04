//
//  AppDelegate.m
//  sText
//
//  Created by pkdev1981 on 30/03/2018.
//  Copyright © 2018 pkdev1981. All rights reserved.
//

#import "AppDelegate.h"
#import "PKStructuredTextViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong) NSViewController *mainVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"json"];
    self.mainVC = [[PKStructuredTextViewController alloc] initWithURL:url];
    
    NSView *realView = self.mainVC.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(realView);
    [realView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSView *v = self.window.contentView;
    [v addSubview:realView];
    [v addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[realView]|" options:0 metrics:nil views:views]];
    [v addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[realView]|" options:0 metrics:nil views:views]];
    
    [self.window recalculateKeyViewLoop];
    [self.window makeFirstResponder:self.mainVC.view];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
