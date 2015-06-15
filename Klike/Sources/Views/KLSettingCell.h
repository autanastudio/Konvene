//
//  KLSettingCell.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"

@interface KLSettingCell : KLFormCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *settingValue;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowIconImageView;
@property (nonatomic, assign) BOOL useCranch; //Sorry, i use this class in many places, so i should add this cranch =(

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       title:(NSString *)title
                       value:(id)value;

@end
