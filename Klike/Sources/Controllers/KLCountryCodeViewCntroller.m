//
//  KLCountryCodeViewCntroller.m
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCountryCodeViewCntroller.h"
#import "KLCountryCodeDataSource.h"

@interface KLCountryCodeViewCntroller () <UISearchBarDelegate, UISearchControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) KLCountryCodeDataSource *dataSource;
@property (nonatomic, strong) KLCountryCodeDataSource *searchDataSource;
@property (nonatomic, strong) SFBasicDataSourceAdapter *searchDataSoruceAdapter;

@end
//Sorry for this =(
static NSString *codeName = @"United States";

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
    [self kl_setTitle:@"COUNTRY CODE" withColor:[UIColor blackColor]];
    [self.dataSource setLastUseedCode:codeName];
    [self.searchDataSource setLastUseedCode:codeName];
    [self kl_setNavigationBarColor:nil];
    UIBarButtonItem *button = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                   target:self
                                                 selector:@selector(dissmissViewController)];
    button.tintColor = [UIColor colorFromHex:0x6466ca];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    [self.searchDataSource registerReusableViewsWithTableView:searchVC.tableView];
    
    UISwipeGestureRecognizer *popGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(dissmissViewController)];
    popGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:popGestureRecognizer];
    
}

- (void)dissmissViewController
{
    if (self.kl_parentViewController) {
        [self.kl_parentViewController viewController:self
                                    dissmissAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissmissCoutryCodeViewControllerWithnewCode:)]) {
        KLCountryCodeDataSource *dataSource;
        if (self.tableView == tableView) {
            dataSource = self.dataSource;
        } else {
            [self.searchController setActive:NO];
            dataSource = self.searchDataSource;
        }
        codeName = [dataSource keyForIndexPath:indexPath];
        [self.delegate dissmissCoutryCodeViewControllerWithnewCode:[dataSource codeForIndexPath:indexPath]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffsetY >0) {
        [self kl_setNavigationBarShadowColor:[UIColor colorFromHex:0xe8e8ed]];
    } else {
        [self kl_setNavigationBarShadowColor:nil];
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
    self.navigationController.navigationBar.translucent = YES;
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
    UITableViewController *tableVC = (UITableViewController *)searchController.searchResultsController;
    tableVC.tableView.contentInset = UIEdgeInsetsMake(64., 0, 0, 0);
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

@end
