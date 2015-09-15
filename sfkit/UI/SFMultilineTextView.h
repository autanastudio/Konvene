//
//  SFMultilineTextView.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 10/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SFMultilineTextView : UITextView

/** The string displayed when the text view is empty */
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, assign) IBInspectable CGFloat preferedMaxLayoutWidth;
@property (nonatomic, strong) NSDictionary *placeholderAttributes;
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic, assign) IBInspectable BOOL alignTextVerticaly;
/*Maximum number of lines allowed*/
@property (nonatomic, assign) IBInspectable NSInteger numberOfLines;


// NOT CALL DIRECTLY
- (void)defaultInit NS_REQUIRES_SUPER;
- (void)showPlaceholder;
- (void)removePlaceholder;


@end
