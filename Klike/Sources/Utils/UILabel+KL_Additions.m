//
//  UILabel+KL_Additions.m
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "UILabel+KL_Additions.h"

@implementation UILabel (KL_Additions)

- (void)setText:(NSString *)text
withMinimumLineHeight:(CGFloat)minimumLineHeight
  strikethrough:(BOOL)needStrikethrough
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = minimumLineHeight;
    style.alignment = self.textAlignment;
    NSDictionary *attr = @{ NSParagraphStyleAttributeName : style,
                            NSForegroundColorAttributeName : self.textColor,
                            NSFontAttributeName : self.font,
                            NSStrikethroughStyleAttributeName :
                            @(needStrikethrough ? NSUnderlineStyleSingle : NSUnderlineStyleNone)};
    self.attributedText = [[NSAttributedString alloc] initWithString:text
                                                          attributes:attr];
}

@end
