//
//  KLFormCell_Private.h
//  Klike
//
//  Created by admin on 07/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"

typedef NS_ENUM(NSInteger, SFFormCellPosition) {
    SFFormCellPositionStandalone,
    SFFormCellPositionFirst,
    SFFormCellPositionMiddle,
    SFFormCellPositionLast,
};

@protocol KLFormCellDelegate <NSObject>

@optional
- (void)formCellDidUpdateContentSize:(KLFormCell *)cell;
- (void)formCellDidCompleteInput:(KLFormCell *)cell;
- (void)formCellDidStartInput:(KLFormCell *)cell;
- (void)formCellDidSubmitInput:(KLFormCell *)cell;
- (void)formCellDidChangeValue:(KLFormCell *)cell;

@end

@interface KLFormCell () <UITextInputTraits>

@property (nonatomic, weak) id<KLFormCellDelegate> delegate;
@property (nonatomic, assign) SFFormCellPosition cellPosition;
@property (nonatomic, readonly) UIResponder *internalResponder;

- (void)_updateImageConstraints;

@end

