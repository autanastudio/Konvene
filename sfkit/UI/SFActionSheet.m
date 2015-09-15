//
//  SFActionSheet.h
//  SocialEvents
//
//  Created by Yarik Smirnov on 08/07/14.
//  Copyright (c) 2014 Softfacade, LLC. All rights reserved.
//

#import "SFActionSheet.h"
#import "SFExtensions.h"

@interface SFActionSheet() <UIActionSheetDelegate>
@property (nonatomic, strong) void (^ actionsHandler)(NSInteger buttonIndex);
@end

@implementation SFActionSheet

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            buttonTitlesArray:(NSArray *)otherButtonTitles
               actionsHandler:(void (^)(NSInteger buttonIndex))handler;
{
    self = [self initWithTitle:title
                      delegate:self
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle
             otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
    if (self) {
        self.actionsHandler = handler;
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (self.actionsHandler && buttonIndex != self.cancelButtonIndex) {
        self.actionsHandler(buttonIndex);
    }
}

/**
 *  Set text color for single button index
 *
 *  @param color Color
 *  @param index Button index
 */
- (void)setTextColor:(UIColor *)color forButtonIndex:(NSInteger)index
{
    self.titleTextColors[@(index)] = color;
}

/**
 *  Set array of text color for array of buttons indexes
 *
 *  @param colors  Array of colors
 *  @param indexes Array of buttons indexes
 */
- (void)setTextColors:(NSArray *)colors forButtonIndexes:(NSArray *)indexes
{
    if (indexes.count != colors.count) {
        return;
    }
    
    for (int i = 0; i < colors.count; i++) {
        self.titleTextColors[indexes[i]] = colors[i];
    }
}

/**
 *  Update text color for buttons indexes
 */


/**
 *  Color for button index from titlesTextColors or base titleTextColor
 *
 *  @param index Button index
 *
 *  @return Color for button at given index
 */
- (UIColor *)colorForIndex:(NSInteger)index {
    if (self.titleTextColors.count == 0) {
        return self.titleTextColor;
    }
    UIColor *color = self.titleTextColors[@(index)];
    if (color == nil)
        color = self.titleTextColor;
    return color;
}

#pragma mark - Lazy properties
- (UIColor *)titleTextColor
{
    if (!_titleTextColor) {
        _titleTextColor = [UIColor blackColor];
    }
    return _titleTextColor;
}

- (NSMutableDictionary *)titleTextColors
{
    if (!_titleTextColors) {
        _titleTextColors = [NSMutableDictionary dictionary];
    }
    return _titleTextColors;
}


@end
