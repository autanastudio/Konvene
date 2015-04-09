//
//  KLMultiLineTexteditForm.m
//  Klike
//
//  Created by admin on 09/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLMultiLineTexteditForm.h"
#import "KLFormCell_Private.h"
#import "SFTextField.h"

@interface KLMultiLineTexteditForm () <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIActivityIndicatorView *validationIndicator;

@end

@implementation KLMultiLineTexteditForm

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
        self.textField = [[SFMultilineTextView alloc] initForAutoLayout];
        [self.contentView addSubview:self.textField];
        self.textField.placeholder = self.placeholder;
        self.textField.placeholderLabel.textColor = [UIColor colorFromHex:0x91919f];
        self.textField.font = [UIFont fontWithFamily:SFFontFamilyNameHelveticaNeue
                                               style:SFFontStyleRegular
                                                size:16.];
        self.textField.textColor = [UIColor blackColor];
        self.textField.delegate = self;
    }
    return self;
}

- (void)setEditingEnable:(BOOL)editingEnable
{
    self.textField.editable = editingEnable;
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
    UIEdgeInsets contentInsets = self.contentInsets;
    contentInsets.bottom += 20.;
    contentInsets.top += 20.;
    self.contentInsets = contentInsets;
    [self.textFieldPins autoRemoveConstraints];
    self.textFieldPins = [self.textField autoPinEdgesToSuperviewEdgesWithInsets:self.contentInsets];
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

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.delegate formCellDidSubmitInput:self];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
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
