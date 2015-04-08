//
//  KLBasicFormCell.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"

@class SFTextField;

@interface KLBasicFormCell : KLFormCell <UITextInputTraits, UITextFieldDelegate>

@property (nonatomic, assign) UIEdgeInsets textFieldInsets;
@property (nonatomic, assign) BOOL editingEnable;
@property (nonatomic, strong) SFTextField *textField;
@property (nonatomic, strong) NSArray *textFieldPins;

@end
