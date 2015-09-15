//
//  SFModalMessageView.m
//  SocialEvents
//
//  Created by Yarik Smirnov on 15/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFAlertMessageView.h"
#import <objc/runtime.h>

@interface SFAlertMessageHandler : NSObject <UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *buttonsActions;
@end

@interface SFAlertMessageView ()
@property (nonatomic, strong) UIAlertView *alertView;
@end

static NSString * const SFAlertMessageCancelTitle = @"Cancel";
static void * const SFAlertMessageHandlerKey = @"SFAlertMessageHandlerKey";

@implementation SFAlertMessageView

+ (SFAlertMessageView *)infoViewWithMessage:(NSString *)message
{
    return [[SFAlertMessageView alloc] initWithTitle:nil
                                             message:message
                                               image:nil
                                        cancelButton:@"Cancel"];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(UIImage *)image
                 cancelButton:(NSString *)cancelTitle
{
    self = [super init];
    if (self) {
        SFAlertMessageHandler *handler = [[SFAlertMessageHandler alloc] init];
        self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:handler
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
        objc_setAssociatedObject(self.alertView, SFAlertMessageHandlerKey, handler, OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (void)setCancelAction:(SFModalMessageAction)action
{
    SFAlertMessageHandler *handler = [self alertHandler];
    handler.buttonsActions[SFAlertMessageCancelTitle] = action;
}

- (void)addActionButtonWithTitle:(NSString *)title action:(SFModalMessageAction)action
{
    [self.alertView addButtonWithTitle:title];
    SFAlertMessageHandler *handler = [self alertHandler];
    handler.buttonsActions[title] = action;
}

- (SFAlertMessageHandler *)alertHandler
{
    SFAlertMessageHandler *handler = objc_getAssociatedObject(self.alertView, SFAlertMessageHandlerKey);
    if (!handler.buttonsActions) {
        handler.buttonsActions = [NSMutableDictionary dictionary];
    }
    return handler;
}

- (void)show
{
    [self.alertView show];
    self.alertView = nil;
}

- (void)hide:(BOOL)animated completion:(void (^)(void))completion
{
    
}

@end

@implementation SFAlertMessageHandler

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        dispatch_block_t action = self.buttonsActions[buttonTitle];
        if (action) {
            action();
        }
    } else {
        dispatch_block_t action = self.buttonsActions[SFAlertMessageCancelTitle];
        if (action) {
            action();
        }
    }
    objc_setAssociatedObject(alertView, SFAlertMessageHandlerKey, nil, OBJC_ASSOCIATION_RETAIN);
}

@end
