//
//  KLCommentDataSource.m
//  Klike
//
//  Created by Alexey on 5/18/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCommentDataSource.h"
#import "KLCommentCell.h"
#import "KLPlaceholderCell.h"

static NSString *klCommentCellReuseId = @"CommentCell";
static NSString *klCommentOwnerCellReuseId = @"CommentOwnerCell";

@interface KLCommentDataSource ()

@property (nonatomic, strong) KLEvent *event;

@end

@implementation KLCommentDataSource

- (instancetype)initWithEvent:(KLEvent *)event
{
    self = [super init];
    if (self) {
        self.event = event;
        self.placeholderView = [[KLPlaceholderCell alloc] initWithTitle:nil
                                                                message:@"No comments yet. Write one!"
                                                                  image:nil
                                                            buttonTitle:nil
                                                           buttonAction:nil];
        self.placeholderView.transform = CGAffineTransformMakeScale(1., -1.);
    }
    return self;
}

- (void)registerReusableViewsWithTableView:(UITableView *)tableView
{
    [super registerReusableViewsWithTableView:tableView];
    [tableView registerNib:[UINib nibWithNibName:klCommentCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCommentCellReuseId];
    [tableView registerNib:[UINib nibWithNibName:klCommentOwnerCellReuseId
                                          bundle:nil]
    forCellReuseIdentifier:klCommentOwnerCellReuseId];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
                         inTableView:(UITableView *)tableView
{
    KLCommentCell *cell;
    KLEventComment *comment = [self itemAtIndexPath:indexPath];
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:comment.owner];
    if ([user isEqualToUser:[KLAccountManager sharedManager].currentUser]) {
        cell = [tableView dequeueReusableCellWithIdentifier:klCommentOwnerCellReuseId];
        [cell configureWithComment:comment isOwner:YES];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:klCommentCellReuseId];
        [cell configureWithComment:comment isOwner:NO];
    }
    cell.transform = CGAffineTransformMakeScale(1., -1.);
    return cell;
}

- (PFQuery *)buildQuery
{
    PFQuery *query = [KLEventComment query];
    [query whereKey:sf_key(objectId) containedIn:self.event.extension.comments];
    query.limit = 10;
    [query includeKey:sf_key(owner)];
    [query orderByDescending:sf_key(createdAt)];
    return query;
}

@end
