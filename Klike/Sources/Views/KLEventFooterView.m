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

@interface KLEventFooterView () <UITableViewDelegate, UITextFieldDelegate, SFDataSourceDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewFullHeightConstraint;

@property (nonatomic, strong) KLEvent *event;
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
    self.tableViewFullHeightConstraint.constant = screenSize.size.height - 48. - 64. - 49.*2; //Double 49 for panels on top and bottom
    
    self.sendCommentButton.enabled = NO;
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
    KLAttributedStringPart *countPart = [KLAttributedStringPart partWithString:commentsCountString
                                                                         color:[UIColor colorFromHex:0xb3b3bd]
                                                                          font:titleFont];
    KLAttributedStringPart *titlePart = [KLAttributedStringPart partWithString:SFLocalized(@"event.comment.title")
                                                                         color:[UIColor colorFromHex:0x6466ca]
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

@end
