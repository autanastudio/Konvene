//
//  KLFormCell.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * KLFormCellReuseIndetifier;

@interface KLFormCell : UITableViewCell

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *placeholder;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readwrite) id value;
@property (nonatomic, readonly) BOOL hasValue;
@property (nonatomic, assign) BOOL needSeparator;

@property (nonatomic, assign) CGFloat minimumHeight;
@property (nonatomic, readonly) UIEdgeInsets backgroundInsets;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets iconInsets;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIView *bottomSeparator;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSMutableArray *constraints;

- (instancetype)initWithName:(NSString *)name
                 placeholder:(NSString *)placehodler
                       image:(UIImage *)image;
- (instancetype)initWithName:(NSString *)name
                 placeholder:(NSString *)placehodler
                       image:(UIImage *)image
                       value:(id)value NS_DESIGNATED_INITIALIZER;
- (NSDictionary *)keyValueRepresentation;

- (void)_updateViewsConfiguration;
- (void)_updateConstraints;

@end