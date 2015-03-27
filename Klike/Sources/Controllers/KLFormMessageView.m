//
//  KLFormMessageView.m
//  Klike
//
//  Created by admin on 11/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormMessageView.h"
#import <Parse/Parse.h>


@interface KLFormMessageView ()
@property (nonatomic, strong) UILabel *messsageLabel;
@end

@implementation KLFormMessageView

- (instancetype)initWithMessage:(NSString *)message
{
    return [self initWithMessage:message
                 backgroundColor:[UIColor whiteColor]];
}

- (instancetype)initWithMessage:(NSString *)message
                backgroundColor:(UIColor *)color
{
    self = [self init];
    if (self) {
        if(color){
            self.backgroundColor = color;
            self.messsageLabel = [[UILabel alloc] initForAutoLayout];
            [self addSubview:self.messsageLabel];
            self.messsageLabel.textAlignment = NSTextAlignmentCenter;
            self.messsageLabel.numberOfLines = 0;
            self.messsageLabel.textColor = [UIColor colorFromHex:0xff5484];
            self.messsageLabel.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue style:SFFontStyleMedium size:16.];
            [self.messsageLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 10, 4, 10)];
            [self.messsageLabel autoSetDimension:ALDimensionHeight
                                          toSize:40
                                        relation:NSLayoutRelationGreaterThanOrEqual];
            self.messsageLabel.text = message;
            
            
        }
    }
    return self;
}

@end
