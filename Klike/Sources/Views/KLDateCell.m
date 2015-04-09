//
//  KLDateCell.m
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLDateCell.h"

@implementation KLDateCell

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
    self.valueLabel.text = [value description];
}

- (void)_updateViewsConfiguration
{
    [super _updateViewsConfiguration];
    
    UIEdgeInsets contentInsets = self.contentInsets;
    contentInsets.top = 16. + contentInsets.top;
    self.contentInsets = contentInsets;
}

- (void)_updateConstraints
{
    [super _updateConstraints];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                      withInset:self.contentInsets.left];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                              withInset:self.contentInsets.right];
    [self.valueLabel autoPinEdge:ALEdgeLeft
                          toEdge:ALEdgeRight
                          ofView:self.titleLabel];
}

@end
