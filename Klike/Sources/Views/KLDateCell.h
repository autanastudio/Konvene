//
//  KLDateCell.h
//  Klike
//
//  Created by admin on 08/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"
#import "KLTimePickerCell.h"

@interface KLDateCell : KLFormCell <KLTimePickerCellDelegate>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *settingValue;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, assign) BOOL showDeleteValueButton;
@property (nonatomic, assign) BOOL showShortDate;

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       title:(NSString *)title
                       value:(id)value;

@end
