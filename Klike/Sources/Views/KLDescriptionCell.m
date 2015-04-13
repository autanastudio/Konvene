//
//  KLDescriptionCell.m
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLDescriptionCell.h"
#import "KLFormCell_Private.h"

@implementation KLDescriptionCell

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
        self.minimumHeight = 96.;
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
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                size:14.];
        self.valueLabel.textColor = [UIColor colorFromHex:0xb3b3bd];
        [self.contentView addSubview:self.valueLabel];
        
        self.descriptionLabel = [[UILabel alloc] initForAutoLayout];
        self.descriptionLabel.font = [UIFont helveticaNeue:SFFontStyleRegular
                                                      size:12.];
        self.descriptionLabel.textColor = [UIColor colorFromHex:0x91919f];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.descriptionLabel];
        
        self.value = value;
    }
    return self;
}

- (void)setValue:(id)value
{
    _value = value;
    if (_value) {
        KLEnumObject *object = (KLEnumObject *)value;
        self.descriptionLabel.text = object.additionalDescriptionString;
        [self.descriptionLabel sizeToFit];
        self.valueLabel.text = object.description;
        if (object.iconNameString.length > 0) {
            self.iconView.image = [UIImage imageNamed:object.iconNameString];
        }
    } else {
        self.valueLabel.text = @"None";
        self.descriptionLabel.text = @"";
    }
}

- (void)_updateViewsConfiguration
{
    [super _updateViewsConfiguration];
    
    UIEdgeInsets contentInsets = self.contentInsets;
    contentInsets.top += 17.;
    self.contentInsets = contentInsets;
}

- (void)_updateConstraints
{
    [super _updateConstraints];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                      withInset:self.contentInsets.left];
    [self.arrowIconImageView autoAlignAxis:ALAxisHorizontal
                          toSameAxisOfView:self.valueLabel withOffset:1.];
    [self.arrowIconImageView autoPinEdgeToSuperviewEdge:ALEdgeRight
                                              withInset:self.contentInsets.right];
    [self.valueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                      withInset:self.contentInsets.top];
    [self.valueLabel autoPinEdge:ALEdgeLeft
                          toEdge:ALEdgeRight
                          ofView:self.titleLabel];
    [self.valueLabel autoPinEdge:ALEdgeRight
                          toEdge:ALEdgeLeft
                          ofView:self.arrowIconImageView
                      withOffset:-9.];
    
    [self.titleLabel autoSetDimension:ALDimensionHeight
                               toSize:20.];
    [self.descriptionLabel autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.titleLabel
                            withOffset:14.];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                            withInset:self.contentInsets.left];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                            withInset:self.contentInsets.right];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:23.];
}

- (void)_updateImageConstraints
{
    if (self.image) {
        [self.iconView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                        withInset:self.iconInsets.top];
        [self.iconView autoPinEdge:ALEdgeRight
                            toEdge:ALEdgeLeft
                            ofView:self.titleLabel
                        withOffset:-8.];
    }
}

@end
