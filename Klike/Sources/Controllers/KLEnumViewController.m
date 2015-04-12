//
//  KLEnumViewController.m
//  Klike
//
//  Created by admin on 12/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEnumViewController.h"
#import "KLEnumDataSource.h"

@interface KLEnumViewController ()
@property (nonatomic, strong) KLEnumDataSource *dataSource;
@property (nonatomic, assign) KLEnumObject *defaultValue;
@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) NSString *customTitle;
@end

@implementation KLEnumViewController

- (instancetype)initWithTitle:(NSString *)titleString
                 defaultvalue:(KLEnumObject *)defaultValue
                  enumObjects:(NSArray *)enumObjects
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.titleString = titleString;
        self.dataSource = [[KLEnumDataSource alloc] init];
        [self.dataSource setItems:enumObjects];
        if (defaultValue) {
            self.defaultValue = defaultValue;
        } else {
            self.defaultValue = enumObjects[0];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:nil];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]
                         target:self
                       selector:@selector(onBack)];
    [self kl_setTitle:self.titleString
            withColor:[UIColor blackColor]];
    NSIndexPath *indexPath = [self.dataSource indexPathsForItem:self.defaultValue][0];
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
}

- (void)onBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(enumViewController:didSelectValue:)]) {
        [self.delegate enumViewController:self
                           didSelectValue:[self.dataSource itemAtIndexPath:indexPath]];
    }
    [self.tableView layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
