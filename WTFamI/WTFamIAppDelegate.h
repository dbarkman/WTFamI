//
//  WTFamIAppDelegate.h
//  WTFamI
//
//  Created by David Barkman on 10/12/12.
//  Copyright (c) 2012 David Barkman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTFamIViewController;

@interface WTFamIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WTFamIViewController *viewController;

@end
