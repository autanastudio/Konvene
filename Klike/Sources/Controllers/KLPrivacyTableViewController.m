//
//  KLPrivacyControllerTableViewController.m
//  Klike
//
//  Created by Dima on 08.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLPrivacyTableViewController.h"
#import "KLEventTypeTableViewCell.h"

@interface KLPrivacyTableViewController ()
@property NSArray *privacyArray;
@property NSArray *privacyImages;
@property NSUInteger currentPrivacy;
@end

@implementation KLPrivacyTableViewController

static NSString *cellId = @"EventTypeCell";

- (instancetype)initWithPrivacy:(NSUInteger)privacy
{
    if (self=[super init]) {
        self.currentPrivacy = privacy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _privacyArray = [NSArray arrayWithObjects:SFLocalizedString(@"event.privacy.public", nil),
                     SFLocalizedString(@"event.privacy.private", nil),
                     SFLocalizedString(@"event.privacy.privateplus",nil), nil];
    _privacyImages = [NSArray arrayWithObjects:@"event_public",
                      @"event_private",
                      @"event_private", nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"KLEventTypeTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:nil];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]
                         target:self
                       selector:@selector(onBack)];
    self.navigationItem.title = SFLocalizedString(@"event.privacy", nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPrivacy inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)onBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _privacyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KLEventTypeTableViewCell *cell = (KLEventTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[KLEventTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellId];
    }
    NSString *key = [_privacyArray objectAtIndex:indexPath.row];
    NSString *imageSrc = [_privacyImages objectAtIndex:indexPath.row];
    [cell configureWithEvent:key imageSrc:imageSrc contentMode:UIViewContentModeRight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _privacyArray.count - 1) {
        cell._viewSeparator.hidden = YES;
    } else {
        cell._viewSeparator.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectPrivacy:)])
        [self.delegate didSelectPrivacy:indexPath.row];
    [self.tableView layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
