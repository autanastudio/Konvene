//
//  KLDescriptionCell.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"
#import "KLSettingCell.h"


@interface KLDescriptionCell : KLFormCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *settingValue;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *arrowIconImageView;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       title:(NSString *)title
                       value:(id)value;

@end
