//
//  KLEventFooterView.m
//  Klike
//
//  Created by admin on 29/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventFooterView.h"
#import "KLCommentCell.h"
#import "KLCommentDataSource.h"
#import "AppDelegate.h"

@interface KLEventFooterView () <UITableViewDelegate, UITextFieldDelegate, SFDataSourceDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) KLEvent *event;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewFullHeightConstraint;
//List properties
@property (nonatomic, strong) SFRefreshControl *refreshControl;
@property (nonatomic, strong) SFBasicDataSourceAdapter *dataSourceAdapter;
@property (nonatomic, strong) KLCommentDataSource *dataSource;
@property (nonatomic, assign) CGFloat contentInsetBottom;

@end

@implementation KLEventFooterView

- (void)awakeFromNib
{
    self.commentTextField.placeholder = SFLocalized(@"event.comment.field.placeholder");
    self.commentTextField.font = [UIFont helveticaNeue:SFFontStyleRegular size:14.];
    self.commentTextField.placeholderColor = [UIColor colorFromHex:0xb3b3bd];
    
    self.dataSourceAdapter = [[SFBasicDataSourceAdapter alloc] initWithTableView:self.tableView];
    self.tableView.delegate = self;
    self.tableView.transform = CGAffineTransformMakeScale(1., -1.);
    self.dataSourceAdapter.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.contentInsetBottom = 0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    CGRect screenSize = [UIScreen mainScreen].bounds;
    self.fullHeight = screenSize.size.height - 48. - 64.- 49.;
    self.tableViewFullHeightConstraint.constant = self.fullHeight - 49.; //Double 49 for panels on top and bottom
    
    self.sendCommentButton.enabled = NO;
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *longTapRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPress:)];
    longTapRec.minimumPressDuration = .5; //seconds
    
    longTapRec.delegate = self;
    longTapRec.delaysTouchesBegan = YES;
    [self.tableView addGestureRecognizer:longTapRec];
}

- (void)configureWithEvent:(KLEvent *)event
{
    self.event = event;
    
    self.dataSource = [self buildDataSource];
    self.dataSource.delegate = self.dataSourceAdapter;
    self.tableView.dataSource = self.dataSource;
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    [self.dataSource loadContentIfNeeded:NO];
    [self updateTitle];
}

- (void)updateTitle
{
    NSString *commentsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.extension.comments.count];
    UIFont *titleFont = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
    UIColor *titleColor;
    if (self.event.extension.comments.count) {
        titleColor = [UIColor colorFromHex:0x6466ca];
    } else {
        titleColor = [UIColor colorFromHex:0xb3b3bd];
    }
    KLAttributedStringPart *countPart = [KLAttributedStringPart partWithString:commentsCountString
                                                                         color:[UIColor colorFromHex:0xb3b3bd]
                                                                          font:titleFont];
    KLAttributedStringPart *titlePart = [KLAttributedStringPart partWithString:SFLocalized(@"event.comment.title")
                                                                         color:titleColor
                                                                          font:titleFont];
    self.commentsTitle.attributedText = [KLAttributedStringHelper stringWithParts:@[titlePart, countPart]];
    
}

- (IBAction)onSend:(id)sender
{
    __weak typeof(self) weakSelf = self;
    weakSelf.sendCommentButton.enabled = NO;
    [[KLEventManager sharedManager] addToEvent:self.event
                                       comment:self.commentTextField.text
                                  completition:^(BOOL succeeded, NSError *error) {
                                      if (succeeded) {
                                          [weakSelf refreshList];
                                          weakSelf.commentTextField.text = @"";
                                          [weakSelf updateTitle];
                                      } else {
                                          weakSelf.sendCommentButton.enabled = YES;
                                      }
    }];
}

- (KLCommentDataSource *)buildDataSource
{
    return [[KLCommentDataSource alloc] initWithEvent:self.event];
}

- (void)refreshList
{
    [self.dataSource loadContentIfNeeded:YES];
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom
{
    _contentInsetBottom = contentInsetBottom;
    if (self.tableView == nil)
        return;
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = contentInsetBottom;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void)addRefrshControlWithActivityIndicator:(KLActivityIndicator *)activityIndicator
{
    SFRefreshControl *control = [[SFRefreshControl alloc] init];
    [control setActivityIndicator:activityIndicator];
    [self.tableView addSubview:control];
    self.refreshControl = control;
    [control addTarget:self
                action:@selector(refreshList)
      forControlEvents:UIControlEventValueChanged];
}

#pragma mark - DataSource

- (void)dataSource:(SFDataSource *)dataSource didLoadContentWithError:(NSError *)error
{
    if (dataSource.loadingStateFinshed) {
        [self.refreshControl endUpdating];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    KLEventComment *comment = [self.dataSource itemAtIndexPath:indexPath];
    KLUserWrapper *user = [[KLUserWrapper alloc] initWithUserObject:comment.owner];
    if (self.delegate && [self.delegate respondsToSelector:@selector(eventFooter:showProfile:)]) {
        [self.delegate eventFooter:self
                       showProfile:user];
    }
}

- (void)didReachEndOfList
{
    if (![self.dataSource.loadingState isEqualToString:SFLoadStateErrorNext]) {
        [self.dataSource setNeedLoadNextPage];
    }
}

- (void)handleScrollDidStop
{
    NSInteger lastSection = self.tableView.numberOfSections - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:lastSection] - 1
                                                    inSection:lastSection];
    if ([self.tableView.indexPathsForVisibleRows containsObject:lastIndexPath]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
        if ([cell.reuseIdentifier isEqualToString:SFLoadingNextCellIdentifier]) {
            [self didReachEndOfList];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        [self handleScrollDidStop];
    }
    [self.refreshControl didRelease];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollDidStop];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (result.length>0) {
        self.sendCommentButton.enabled = YES;
    } else {
        self.sendCommentButton.enabled = NO;
    }
    return YES;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"couldn't find index path");
    } else {
        KLUserWrapper *currentUser = [KLAccountManager sharedManager].currentUser;
        KLUserWrapper *eventOwner = [[KLUserWrapper alloc] initWithUserObject:self.event.owner];
        KLEventComment *comment = [self.dataSource itemAtIndexPath:indexPath];
        KLUserWrapper *commentOwner = [[KLUserWrapper alloc] initWithUserObject:comment.owner];
        if ([currentUser isEqualToUser:commentOwner] || [currentUser isEqualToUser:eventOwner]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete this comment?"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            __weak typeof(self) weakSelf = self;
            UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * action) {
                                                                     [[KLEventManager sharedManager] deleteComment:weakSelf.event
                                                                                                           comment:comment
                                                                                                      completition:^(BOOL succeeded, NSError *error) {
                                                                                                          if (succeeded) {
                                                                                                              [weakSelf refreshList];
                                                                                                          }
                                                                     }];
                                                                  }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action) {
            }];
            [alert addAction:deleteAction];
            [alert addAction:cancelAction];
            [[ADI currentNavigationController] presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }
}

@end
