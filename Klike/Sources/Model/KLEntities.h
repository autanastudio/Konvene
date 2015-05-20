//
//  KLEntities.h
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#ifndef Klike_KLEntities_h
#define Klike_KLEntities_h

typedef void(^klCompletitionHandlerWithObject)(id object, NSError *error);
typedef void(^klCompletitionHandlerWithObjects)(NSArray *objects, NSError *error);
typedef void(^klCompletitionHandlerWithoutObject)(BOOL succeeded, NSError *error);

#import "KLCard.h"
#import "KLUserPayment.h"
#import "KLUserWrapper.h"
#import "KLEventPrice.h"
#import "KLEventExtension.h"
#import "KLEvent.h"
#import "KLCharge.h"
#import "KLLocation.h"
#import "KLInvite.h"
#import "KLActivity.h"
#import "KLEventComment.h"

#endif
