//
//  KLExplorePeopleListController.m
//  Klike
//
//  Created by Alexey on 4/21/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExplorePeopleListController.h"
#import "KLExplorePeopleDataSource.h"
#import "KLActivityIndicator.h"
#import "KLExplorePeopleSearchDataSource.h"

static CGFloat klExplorePeopleCellHeight = 64.;

@interface KLExplorePeopleListController () <UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) KLExplorePeopleSearchDataSource *searchDataSource;
@property (nonatomic, assign) KLExplorePeopleListState state;
@property (nonatomic, strong) NSString *searchString;

@end

@implementation KLExplorePeopleListController

- (instancetype)init
{
    if (self = [super init]) {
        self.state = KLExplorePeopleListStateDefault;
        self.searchString = @"";
    }
    return self;
}

- (SFDataSource *)buildDataSource
{
    KLExplorePeopleDataSource *dataSource = [[KLExplorePeopleDataSource alloc] init];
    return dataSource;
}

- (NSString *)title
{
    return SFLocalized(@"explore.people.title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRefrshControlWithActivityIndicator:[KLActivityIndicator colorIndicator]];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = klExplorePeopleCellHeight;
    
    self.searchDataSource = [[KLExplorePeopleSearchDataSource alloc] init];
    self.searchDataSource.delegate = self.dataSource.delegate;
    [self.searchDataSource registerReusableViewsWithTableView:self.tableView];
    self.searchBar = [[UISearchBar alloc] initWithFrame:YSRectMakeFromSize(self.tableView.width, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"Search";
    self.tableView.tableHeaderView = self.searchBar;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
}

- (void)refreshList
{
    [super refreshList];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFDataSource *currentDataSource = self.searchBar.isFirstResponder ? self.searchDataSource : self.dataSource;
    if ([currentDataSource obscuredByPlaceholder]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(explorePeopleList:openUserProfile:)]) {
        PFUser *userObject = [currentDataSource itemAtIndexPath:indexPath];
        KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:userObject];
        [self.delegate explorePeopleList:self openUserProfile:userWrapper];
    }
}

- (void)didReachEndOfList
{
    if (self.searchBar.isFirstResponder) {
        return;
    }
    if (![self.dataSource.loadingState isEqualToString:SFLoadStateErrorNext]) {
        [self.dataSource setNeedLoadNextPage];
    }
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    [self.searchDataSource setNeedLoadSearchContentWithQuery:searchText];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (self.state == KLExplorePeopleListStateDefault) {
        self.state = KLExplorePeopleListStateSearch;
        self.tableView.dataSource = self.searchDataSource;
        [searchBar setShowsCancelButton:YES
                               animated:NO];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.state = KLExplorePeopleListStateDefault;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
    [searchBar setShowsCancelButton:NO
                           animated:NO];
}

@end
