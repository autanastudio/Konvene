//
//  KLFormCell.m
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"
#import "KLFormCell_Private.h"

NSString * KLFormCellReuseIndetifier = @"KLFormCellReuseIndetifier";

@interface KLFormCell ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSLayoutConstraint *miminumHeightConstraint;
@property (nonatomic, assign) UIEdgeInsets backgroundInsets;

@end

@implementation KLFormCell

- (instancetype)init
{
    return [self initWithName:nil
                  placeholder:nil
                        image:nil
                        value:nil];
}

- (instancetype)initWithName:(NSString *)name
                 placeholder:(NSString *)placehodler
                       image:(UIImage *)image
                       value:(id)value
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLFormCellReuseIndetifier];
    if (self) {
        _name = name;
        _placeholder = placehodler;
        _image = image;
        _value = value;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _minimumHeight = 48.0;
        self.backgroundColor = [UIColor clearColor];
        _cellPosition = SFFormCellPositionStandalone;
        
        _background = [[UIImageView alloc] initForAutoLayout];
        _background.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:_background atIndex:0];
        
        self.bottomSeparator = [[UIView alloc] initForAutoLayout];
        self.bottomSeparator.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
        [self.contentView addSubview:self.bottomSeparator];
        [self.bottomSeparator autoSetDimension:ALDimensionHeight toSize:1.];
        
        if (self.image) {
            _iconView = [[UIImageView alloc] initForAutoLayout];
            _iconView.image = self.image;
            _iconView.contentMode = UIViewContentModeCenter;
            [self.contentView addSubview:_iconView];
            self.iconInsets = UIEdgeInsetsZero;
        }
        
        self.needSeparator = YES;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                 placeholder:(NSString *)placehodler
                       image:(UIImage *)image
{
    return [self initWithName:name
                  placeholder:placehodler
                        image:image
                        value:nil];
}

- (BOOL)hasValue
{
    return self.value != nil;
}

- (NSDictionary *)keyValueRepresentation
{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:1];
    [map sf_setObject:self.value forKey:self.name];
    return map.copy;
}

- (void)setCellPosition:(SFFormCellPosition)cellPosition
{
    _cellPosition = cellPosition;
    [self _updateViewsConfiguration];
}

- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight = minimumHeight;
    [self _updateViewsConfiguration];
}

- (void)_updateViewsConfiguration
{
    switch (self.cellPosition) {
        case SFFormCellPositionStandalone:
            self.bottomSeparator.hidden = YES;
            self.backgroundInsets = UIEdgeInsetsMake(0, 0, 4, 0);
            break;
        case SFFormCellPositionFirst:
            self.bottomSeparator.hidden = !self.needSeparator;
            self.backgroundInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        case SFFormCellPositionMiddle:
            self.bottomSeparator.hidden = !self.needSeparator;
            self.backgroundInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        case SFFormCellPositionLast:
            self.bottomSeparator.hidden = YES;
            self.backgroundInsets = UIEdgeInsetsMake(0, 0, 4, 0);
            break;
    }
    UIEdgeInsets bgInsets = self.backgroundInsets;
    bgInsets.left = 38.5 + bgInsets.left;
    bgInsets.right = 16. + bgInsets.right;
    bgInsets.top = -1. + bgInsets.top;
    self.contentInsets = bgInsets;
    [self setNeedsUpdateConstraints];
}

- (void)_updateConstraints
{
    _constraints = [NSMutableArray array];
    
    [_constraints addObjectsFromArray:[_background autoPinEdgesToSuperviewEdgesWithInsets:self.backgroundInsets]];
    [UIView autoSetPriority:999 forConstraints:^{
        self.miminumHeightConstraint = [_background autoSetDimension:ALDimensionHeight
                                                              toSize:self.minimumHeight
                                                            relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    [_constraints addObject:self.miminumHeightConstraint];
    
    [_constraints addObjectsFromArray:[self.bottomSeparator autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 40, 0, 0)
                                                                                     excludingEdge:ALEdgeTop]];
    [self _updateImageConstraints];
}

- (void)_updateImageConstraints
{
    if (self.image) {
        [_iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                    withInset:self.iconInsets.left];
        [_iconView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                    withInset:self.iconInsets.top];
    }
}

- (void)updateConstraints
{
    if (!_constraints) {
        [self _updateConstraints];
    }
    self.miminumHeightConstraint.constant = self.minimumHeight + self.backgroundInsets.top + self.backgroundInsets.bottom;
    [super updateConstraints];
}

@end
