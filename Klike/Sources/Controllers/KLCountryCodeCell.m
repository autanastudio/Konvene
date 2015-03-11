//
//  KLCountryCodeCell.m
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCountryCodeCell.h"

@interface KLCountryCodeCell()

@property (nonatomic, strong) UILabel *countryNameLabel;
@property (nonatomic, strong) UILabel *countryCodeLabel;

@end

@implementation KLCountryCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.countryNameLabel = [[UILabel alloc] init];
        self.countryNameLabel.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                      style:SFFontStyleRegular
                                                       size:16];
        self.countryNameLabel.textColor = [UIColor blackColor];
        self.countryNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.countryNameLabel];
        self.countryCodeLabel = [[UILabel alloc] init];
        self.countryCodeLabel.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                                      style:SFFontStyleRegular
                                                       size:16];
        self.countryCodeLabel.textColor = [UIColor colorFromHex:0x8e8e92];
        self.countryCodeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.countryCodeLabel];
        [self.countryNameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 15, 0, 0)
                                                        excludingEdge:ALEdgeRight];
        [self.countryCodeLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 15)
                                                        excludingEdge:ALEdgeLeft];
        [self.countryCodeLabel autoPinEdge:ALEdgeLeft
                                    toEdge:ALEdgeRight
                                    ofView:self.countryNameLabel];
    }
    return self;
}

- (void)configureWithCountry:(NSString *)country
                        code:(NSString *)code
{
    self.countryNameLabel.text = country;
    self.countryCodeLabel.text = code;
}

@end
