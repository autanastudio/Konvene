//
//  KLEventPageCell.h
//  Klike
//
//  Created by admin on 04/05/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLeventPageCellDelegate <NSObject>

@end

@interface KLEventPageCell : UITableViewCell

@property (readwrite, nonatomic, strong) KLEvent *event;
@property (nonatomic, weak) id<KLeventPageCellDelegate> delegate;

- (void)configureWithEvent:(KLEvent *)event;

@end
