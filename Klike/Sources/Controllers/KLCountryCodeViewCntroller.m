//
//  KLCountryCodeViewCntroller.m
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCountryCodeViewCntroller.h"
#import "KLCountryCodeDataSource.h"

@interface KLCountryCodeViewCntroller () <UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) NSDictionary *countryCodesDictionary;
@property (nonatomic, strong) NSArray *countryCodeKeys;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) KLCountryCodeDataSource *dataSource;
@property (nonatomic, strong) KLCountryCodeDataSource *searchDataSource;

@end

@implementation KLCountryCodeViewCntroller

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.dataSource = [[KLCountryCodeDataSource alloc] init];
        self.searchDataSource = [[KLCountryCodeDataSource alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"COUNTRY CODE";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    [self.tableView setDataSource:self.dataSource];
    
    UITableViewController *searchVC = [[UITableViewController alloc] init];
    searchVC.tableView.dataSource = self.searchDataSource;
    searchVC.tableView.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchVC];
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = YSRectMakeFromSize(self.tableView.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    [self.searchDataSource registerReusableViewsWithTableView:searchVC.tableView];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchDataSource setNeedLoadSearchContentWithQuery:searchText];
}

#pragma mark - UISearchControllerDelegate methods

- (void)willPresentSearchController:(UISearchController *)searchController
{
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
}

@end
