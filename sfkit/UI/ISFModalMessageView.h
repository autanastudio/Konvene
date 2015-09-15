//
//  ISFModalMessageView.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 16/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

/*
 Abstract
 Provide UI blocking modal view with optional title, message image and button;
 */


typedef void (^ SFModalMessageAction)() ;

@protocol ISFModalMessageView <NSObject>

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(UIImage *)image
                 cancelButton:(NSString *)cancelTitle;
- (void)setCancelAction:(SFModalMessageAction)action;
- (void)addActionButtonWithTitle:(NSString *)title action:(SFModalMessageAction)action;
- (void)show;
- (void)hide:(BOOL)animated completion:(void (^)(void))completion;

@end