//
//  KLObjectListTableViewController.m
//  Klike
//
//  Created by Дмитрий Александров on 06.04.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//
#import "KLEventTypeTableViewController.h"
#import "KLEventTypeDataSource.h"

@interface KLEventTypeTableViewController ()
@property (nonatomic, strong) KLEventTypeDataSource *dataSource;
@property (nonatomic, strong) NSString *defaultValue;
@end

@implementation KLEventTypeTableViewController

- (instancetype)initWithDefaultValue:(NSString *)defaultValue
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.dataSource = [[KLEventTypeDataSource alloc] init];
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)setSelectedType:(NSString *) type
{
    [[self.tableView cellForRowAtIndexPath:[self.dataSource getIndexPathForType:type]] setSelected:YES animated:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self kl_setNavigationBarColor:nil];
    [self kl_setBackButtonImage:[UIImage imageNamed:@"arrow_back"]
                         target:self
                       selector:@selector(onBack)];
    self.navigationItem.title = SFLocalizedString(@"event.type.title", nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    NSIndexPath *indexPath = [self.dataSource getIndexPathForType:self.defaultValue];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:
     UITableViewScrollPositionNone];
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
    if ([self.delegate respondsToSelector:@selector(didSelectType:)])
        [self.delegate didSelectType:[self.dataSource keyForIndexPath:indexPath]];
    [self.tableView layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
