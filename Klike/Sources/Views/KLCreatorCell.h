//
//  KLCreatorCell.h
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLUserListCell.h"



@protocol KLCreatorCellDelegate <NSObject>

- (void)creatorCellDelegateDidPress;

@end



@interface KLCreatorCell : KLUserListCell

@property (nonatomic, weak)id<KLCreatorCellDelegate>delegate;

@end
