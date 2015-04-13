//
//  KLSettingCell.m
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLSettingCell.h"
#import "KLFormCell_Private.h"

@implementation KLSettingCell

@synthesize value = _value;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       title:(NSString *)title
                       value:(id)value
{
    self = [super initWithName:name
                   placeholder:nil
                         image:image
                         value:value];
    if (self) {
        self.minimumHeight = 48.;
        self.title = title;
        
        self.titleLabel = [[UILabel alloc] initForAutoLayout];
        self.titleLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                size:14.];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.text = self.title;
        
        UIImage *arrowImage = [UIImage imageNamed:@"ic_ar_rht"];
        self.arrowIconImageView = [[UIImageView alloc] initWithImage:arrowImage];
        [self.arrowIconImageView autoSetDimensionsToSize:arrowImage.size];
        [self.contentView addSubview:self.arrowIconImageView];
        
        self.valueLabel = [[UILabel alloc] initForAutoLayout];
        self.value = value;
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                size:14.];
        self.valueLabel.textColor = [UIColor colorFromHex:0xb3b3bd];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)setValue:(id)value
{
    _value = value;
    if (_value) {
        self.valueLabel.text = [value description];
    } else {
        self.valueLabel.text = @"None";
    }
}

- (void)_updateConstraints
{
    [super _updateConstraints];
    [self.titleLabel autoAlignAxis:ALAxisHorizontal
                  toSameAxisOfView:self.contentView
                        withOffset:-self.contentInsets.bottom];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                      withInset:self.contentInsets.left];
    [self.arrowIconImageView autoAlignAxis:ALAxisHorizontal
                          toSameAxisOfView:self.valueLabel withOffset:1.];
    [self.arrowIconImageView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                              withInset:self.contentInsets.right];
    [self.valueLabel autoAlignAxis:ALAxisHorizontal
                  toSameAxisOfView:self.contentView
                        withOffset:-self.contentInsets.bottom];
    [self.valueLabel autoPinEdge:ALEdgeLeft
                          toEdge:ALEdgeRight
                          ofView:self.titleLabel];
    [self.valueLabel autoPinEdge:ALEdgeRight
                          toEdge:ALEdgeLeft
                              ofView:self.arrowIconImageView
                      withOffset:-9.];
}

@end
