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
    if (self = [super initWithName:name
                             image:image
                             title:title
                             value:value]) {
        self.minimumHeight = 100.;
        
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
    KLEnumObject *object = (KLEnumObject *)value;
    self.descriptionLabel.text = object.additionalDescriptionString;
    [self.descriptionLabel sizeToFit];
    self.valueLabel.text = object.description;
    if (object.iconNameString.length > 0) {
        self.iconView.image = [UIImage imageNamed:object.iconNameString];
    }
}

- (void)_updateViewsConfiguration
{
    [super _updateViewsConfiguration];
    
    UIEdgeInsets contentInsets = self.contentInsets;
    contentInsets.top = 3. + contentInsets.top;
    self.contentInsets = contentInsets;
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

- (void)_updateConstraints
{
    [super _updateConstraints];
    [self.titleLabel autoSetDimension:ALDimensionHeight
                               toSize:20.];
    [self.descriptionLabel autoPinEdge:ALEdgeTop
                                toEdge:ALEdgeBottom
                                ofView:self.titleLabel
                            withOffset:15.];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                            withInset:self.contentInsets.left];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                            withInset:self.contentInsets.right];
    [self.descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:23.];
}

@end
