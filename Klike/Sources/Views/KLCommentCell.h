//
//  KLCommentCell.h
//  Klike
//
//  Created by Alexey on 5/18/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLCommentCell : UITableViewCell

- (void)configureWithComment:(KLEventComment *)comment
                     isOwner:(BOOL)isOwner;

@end
