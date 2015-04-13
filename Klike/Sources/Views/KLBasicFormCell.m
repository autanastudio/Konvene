//
//  KLBasicFormCell.m
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLBasicFormCell.h"
#import "KLFormCell_Private.h"
#import "SFTextField.h"

@interface KLBasicFormCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIActivityIndicatorView *validationIndicator;

@end

@implementation KLBasicFormCell

@synthesize value = _value;

- (instancetype)initWithName:(NSString *)name
                 placeholder:(NSString *)placehodler
                       image:(UIImage *)image
                       value:(id)value
{
    self = [super initWithName:name
                   placeholder:placehodler
                         image:image
                         value:value];
    if (self) {
        self.textField = [[SFTextField alloc] initForAutoLayout];
        [self.contentView addSubview:self.textField];
        self.textField.placeholder = self.placeholder;
        self.textField.placeholderColor = [UIColor colorFromHex:0x91919f];
        self.textField.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                               style:SFFontStyleRegular
                                                size:16.];
        self.textField.textColor = [UIColor blackColor];
        self.textField.delegate = self;
        [self.textField addTarget:self
                           action:@selector(onTextFieldDidChange)
                 forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setEditingEnable:(BOOL)editingEnable
{
    self.textField.enabled = editingEnable;
}

- (void)_updateViewsConfiguration
{
    [super _updateViewsConfiguration];
    switch (self.cellPosition) {
        case SFFormCellPositionStandalone:
            self.textField.returnKeyType = UIReturnKeyDone;
            break;
        case SFFormCellPositionFirst:
            self.textField.returnKeyType = UIReturnKeyNext;
            break;
        case SFFormCellPositionMiddle:
            self.textField.returnKeyType = UIReturnKeyNext;
            break;
        case SFFormCellPositionLast:
            self.textField.returnKeyType = UIReturnKeyDone;
            break;
    }
}

- (void)_updateConstraints
{
    [super _updateConstraints];
}

- (void)updateConstraints
{
    [self.textFieldPins autoRemoveConstraints];
    NSMutableArray *pins = [NSMutableArray array];
    [pins addObject:[self.textField autoAlignAxis:ALAxisHorizontal
                                 toSameAxisOfView:self.contentView
                                       withOffset:-self.contentInsets.bottom]];
    [pins addObject:[self.textField autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                     withInset:self.contentInsets.left]];
    [pins addObject:[self.textField autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                     withInset:self.contentInsets.right]];
    self.textFieldPins = pins;
    [super updateConstraints];
}

- (void)setTextFieldInsets:(UIEdgeInsets)textFieldInsets
{
    _textFieldInsets = textFieldInsets;
    [self setNeedsUpdateConstraints];
}

- (BOOL)hasValue
{
    return [self.textField.text notEmpty];
}

- (id)value
{
    return self.textField.text;
}

- (void)setValue:(id)value
{
    _value = value;
    self.textField.text = [value description];
}

- (UIResponder *)internalResponder
{
    return self.textField;
}

- (NSDictionary *)keyValueRepresentation
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:1];
    [map sf_setObject:self.textField.text forKey:self.name];
    return map.copy;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(formCellDidCompleteInput:)]) {
        [self.delegate formCellDidCompleteInput:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(formCellDidStartInput:)]) {
        [self.delegate formCellDidStartInput:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(formCellDidSubmitInput:)]) {
        [self.delegate formCellDidSubmitInput:self];
    }
    return YES;
}

- (void)onTextFieldDidChange
{
    if ([self.delegate respondsToSelector:@selector(formCellDidChangeValue:)]) {
        [self.delegate formCellDidChangeValue:self];
    }
}


#pragma mark - UIResponder methods

- (BOOL)canBecomeFirstResponder
{
    return [self.internalResponder canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [self.internalResponder becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [self.internalResponder canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.internalResponder resignFirstResponder];
}

#pragma mark - UITextInputTraints properties


- (void)setReturnKey:(UIReturnKeyType)returnKey
{
    self.textField.returnKeyType = returnKey;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textField.keyboardType = keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    self.textField.autocapitalizationType = autocapitalizationType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    self.textField.autocorrectionType = autocorrectionType;
}

@end
