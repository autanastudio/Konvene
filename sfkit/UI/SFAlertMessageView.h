//
//  SFModalMessageView.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 15/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISFModalMessageView.h"

@interface SFAlertMessageView : NSObject <ISFModalMessageView>

+ (SFAlertMessageView *)infoViewWithMessage:(NSString *)message;

@end
