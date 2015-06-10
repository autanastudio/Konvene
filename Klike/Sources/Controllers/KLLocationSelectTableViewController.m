//
//  KLLocationSelectTableViewController.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocationSelectTableViewController.h"
#import "KLLocation.h"
#import "KLLocationManager.h"
#import "SFComposedDataSource.h"

@interface KLLocationSelectTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SFDataSource *dataSource;
@property (nonatomic, strong) KLLocationDataSource *recentDataSource;
@property (nonatomic, strong) KLLocationDataSource *placesDataSource;
@property (nonatomic, strong) SFBasicDataSourceAdapter *dataSoruceAdapter;
@end

@implementation KLLocationSelectTableViewController

- (instancetype)initWithType:(KLLocationSelectType)type
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        if (type == KLLocationSelectTypeParse) {
            self.placesDataSource = [[KLLocationDataSource alloc] initWithType:type];
            self.dataSource = self.placesDataSource;
        } else {
            self.placesDataSource = [[KLLocationDataSource alloc] initWithType:type];
            self.recentDataSource = [[KLLocationDataSource alloc] initWithType:KLLocationSelectTypeRecent];
            SFComposedDataSource *dataSource = [[SFComposedDataSource alloc] init];
            [dataSource addDataSource:self.placesDataSource];
            [dataSource addDataSource:self.recentDataSource];
            self.dataSource = dataSource;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    UIBarButtonItem *button = [self kl_setBackButtonImage:[UIImage imageNamed:@"ic_back"]
                                                   target:self
                                                 selector:@selector(dissmissViewController)];
    button.tintColor = [UIColor colorFromHex:0x6466ca];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.dataSource loadContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *poweredByGoogleImg = [UIImage imageNamed:@"powered-by-google-on-white"];
    CGSize logoSize = poweredByGoogleImg.size;
    logoSize.height += 8.;
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:YSRectMakeFromSize(logoSize.width, logoSize.height)];
    logoImage.image = poweredByGoogleImg;
    [logoImage setContentMode:UIViewContentModeBottom];
    [self.tableView setTableFooterView:logoImage];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataSoruceAdapter = [[SFBasicDataSourceAdapter alloc] initWithTableView:self.tableView];
    self.dataSource.delegate = self.dataSoruceAdapter;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame = YSRectMakeFromSize(self.tableView.width, 44.0);
    self.searchController.searchBar.showsCancelButton = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.edgesForExtendedLayout = UIRectEdgeNone;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    
}

- (void)dissmissViewController
{
    self.searchController.active = NO;
    if (self.kl_parentViewController) {
        [self.kl_parentViewController viewController:self
                                    dissmissAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.;
    } else {
        return 52.;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    } else {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor clearColor];
        
        UILabel *recentLabel = [[UILabel alloc] init];
        recentLabel.textColor = [UIColor blackColor];
        recentLabel.font = [UIFont helveticaNeue:SFFontStyleRegular size:14.];
        recentLabel.text = @"RECENT";
        
        [header addSubview:recentLabel];
        [recentLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [recentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16.];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource obscuredByPlaceholder]) {
        return;
    }
    self.searchController.active = NO;
    KLLocation *currentVenue = [self.dataSource itemAtIndexPath:indexPath];
    if (currentVenue.custom) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SFLocalized(@"location.alertmessage.title")
                                                            message:SFLocalized(@"location.alertmessage.message")
                                                           delegate:self
                                                  cancelButtonTitle:SFLocalized(@"location.alertmessage.button.close")
                                                  otherButtonTitles:SFLocalized(@"location.alertmessage.button.settings"), nil];
            [alert show];
        } else {
            __weak typeof(self) weakSelf = self;
            [[KLLocationManager sharedManager] getCurrentPlaceWithLocation:currentVenue.location completion:^(KLLocation *currentPlace) {
                if (currentPlace) {
                    [weakSelf.delegate dissmissLocationSelectTableView:weakSelf
                                                             withVenue:currentPlace];
                }
            }];
        }
    } else {
        [self.delegate dissmissLocationSelectTableView:self
                                             withVenue:currentVenue];
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
    if (searchText.length>0) {
        self.placesDataSource.input = searchText;
        [self.placesDataSource loadContent];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

#pragma mark - UISearchControllerDelegate methods

- (void)willPresentSearchController:(UISearchController *)searchController
{
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchController.searchBar.showsCancelButton = NO;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
//    searchController.searchBar.showsCancelButton = NO;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
