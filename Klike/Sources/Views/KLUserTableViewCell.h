//
//  KLUserTableViewCell.h
//  Klike
//
//  Created by Дмитрий Александров on 01.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLUserWrapper, KLUserTableViewCell;

@protocol KLUserTableViewCellDelegate <NSObject>
- (void) cellDidClickFollow:(KLUserTableViewCell *)cell;
@end

@interface KLUserTableViewCell : UITableViewCell
@property KLUserWrapper *user;
@property (nonatomic, weak) id <KLUserTableViewCellDelegate> delegate;

- (void)configureWithUser:(KLUserWrapper *)user;

@end
