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

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) NSDictionary *countryCodesDictionary;
@property (nonatomic, strong) NSArray *countryCodeKeys;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) KLCountryCodeDataSource *dataSource;
@property (nonatomic, strong) KLCountryCodeDataSource *searchDataSource;
@property (nonatomic, strong) SFBasicDataSourceAdapter *searchDataSoruceAdapter;

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
    [self kl_setTitle:SFLocalized(@"COUNTRY CODE")];
    [self kl_setNavigationBarColor:nil];
    [self kl_setNavigationBarTitleColor:[UIColor blackColor]];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self.dataSource;
    
    UITableViewController *searchVC = [[UITableViewController alloc] init];
    searchVC.tableView.dataSource = self.searchDataSource;
    searchVC.tableView.delegate = self;
    self.searchDataSoruceAdapter = [[SFBasicDataSourceAdapter alloc] initWithTableView:searchVC.tableView];
    self.searchDataSource.delegate = self.searchDataSoruceAdapter;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchVC];
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = YSRectMakeFromSize(self.tableView.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissCoutryCodeViewControllerWithnewCode:)]) {
        KLCountryCodeDataSource *dataSource;
        if (self.tableView == tableView) {
            dataSource = self.dataSource;
        } else {
            [self.searchController setActive:NO];
            dataSource = self.searchDataSource;
        }
        [self.delegate dissmissCoutryCodeViewControllerWithnewCode:[dataSource codeForIndexPath:indexPath]];
    }
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
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

@end
