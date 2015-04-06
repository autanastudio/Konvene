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
@end

@implementation KLEventTypeTableViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.dataSource = [[KLEventTypeDataSource alloc] init];
    }
    return self;
}

- (void)setSelectedType:(NSString *) type
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[self.dataSource getIndexPathForType:type]];
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
    [self.dataSource registerReusableViewsWithTableView:self.tableView];
    [self setSelectedType:@"None"];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(didSelectType:)])
        [self.delegate didSelectType:[self.dataSource keyForIndexPath:indexPath]];
   
    cell.accessoryView.hidden = NO;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryView.hidden = YES;
}

@end
