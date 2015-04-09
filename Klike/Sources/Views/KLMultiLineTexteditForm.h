//
//  KLMultiLineTexteditForm.h
//  Klike
//
//  Created by admin on 09/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"
#import "SFMultilineTextView.h"

@interface KLMultiLineTexteditForm : KLFormCell <UITextInputTraits, UITextFieldDelegate>

@property (nonatomic, assign) UIEdgeInsets textFieldInsets;
@property (nonatomic, assign) BOOL editingEnable;
@property (nonatomic, strong) SFMultilineTextView *textField;
@property (nonatomic, strong) NSArray *textFieldPins;

@end
