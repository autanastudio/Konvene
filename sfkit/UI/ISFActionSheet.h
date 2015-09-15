//
//  ISFActionSheet.h
//  Livid
//
//  Created by Yarik Smirnov on 2/20/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ SFActionSheetActionHandler)();

@protocol ISFActionSheet <NSObject>

- (instancetype)initWithTitle:(NSString *)title
                      actions:(NSArray *)actions
                 cancelButton:(NSString *)cancelButton;
- (void)addActionWithTitle:(NSString *)title handler:(SFActionSheetActionHandler)handler;

@end
