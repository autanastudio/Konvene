//
//  SFActionSheet.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Subclass of UIActionSheet for setting text color in buttons for given indexes
 */
@interface SFActionSheet : UIActionSheet
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) NSMutableDictionary *titleTextColors;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            buttonTitlesArray:(NSArray *)otherButtonTitles
               actionsHandler:(void (^)(NSInteger buttonIndex))handler;

/**
 *  Set text color for given button index
 *
 *  @param color Color
 *  @param index Button index
 */
- (void)setTextColor:(UIColor *)color forButtonIndex:(NSInteger)index;

/**
 *  Set array of text color for array of buttons indexes
 *
 *  @param colors  Array of colors
 *  @param indexes Array of buttons indexes
 */
- (void)setTextColors:(NSArray *)colors forButtonIndexes:(NSArray *)indexes;

@end
