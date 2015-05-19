//
//  UILabel+KL_Additions.h
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (KL_Additions)

- (void)setText:(NSString *)text
withMinimumLineHeight:(CGFloat)minimumLineHeight
  strikethrough:(BOOL)needStrikethrough;

@end
