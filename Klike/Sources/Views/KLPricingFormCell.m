//
//  KLPricingFormCell.m
//  Klike
//
//  Created by Alexey on 5/12/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPricingFormCell.h"
#import "KLFormCell_Private.h"
#import "KLPricingView.h"

@interface KLPricingFormCell ()

@property (nonatomic, strong) KLPricingView *pricingView;

@end

@implementation KLPricingFormCell

@synthesize value = _value;

- (instancetype)initWithName:(NSString *)name
                       value:(id)value
{
    self = [super initWithName:name
                   placeholder:nil
                         image:nil
                         value:value];
    if (self) {
        _value = value;
        self.minimumHeight = 44.;
        KLEventPrice *price = (KLEventPrice *)value;
        switch ([price.pricingType integerValue]) {
            case KLEventPricingTypePayed:{
                UINib *nib = [UINib nibWithNibName:@"PayedPricingView" bundle:nil];
                self.pricingView = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
            }break;
            case KLEventPricingTypeThrow:{
                UINib *nib = [UINib nibWithNibName:@"ThrowPricingView" bundle:nil];
                self.pricingView = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
            }break;
            default:{
                UINib *nib = [UINib nibWithNibName:@"FreePricingView" bundle:nil];
                self.pricingView = [nib instantiateWithOwner:nil
                                                     options:nil].firstObject;
            }break;
        }
        [self.pricingView configureWithPrice:price];
        [self.contentView addSubview:self.pricingView];
    }
    return self;
}

- (void)setValue:(id)value
{
    _value = value;
}

- (id)value
{
    return self.pricingView.price;
}

- (void)_updateConstraints
{
    [super _updateConstraints];
    UIEdgeInsets viewInsets = UIEdgeInsetsZero;
    viewInsets.bottom = self.contentInsets.bottom;
    [self.pricingView autoPinEdgesToSuperviewEdgesWithInsets:viewInsets];
}

@end
