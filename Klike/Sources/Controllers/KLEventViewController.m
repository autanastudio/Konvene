//
//  KLEventViewController.m
//  Klike
//
//  Created by admin on 28/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventViewController.h"
#import "KLEventHeaderView.h"
#import "KLEventFooterView.h"
#import "KLEventDetailsCell.h"
#import "KLEventDescriptionCell.h"
#import "KLEventPaymentCell.h"
#import "KLEventGalleryCell.h"
#import "KLEventLocationCell.h"
#import "KLStaticDataSource.h"


@interface KLEventViewController () <KLeventPageCellDelegate>

@property (nonatomic, strong) KLEventHeaderView *header;
@property (nonatomic, strong) KLEventFooterView *footer;

@property (nonatomic, strong) KLEventDetailsCell *detailsCell;
@property (nonatomic, strong) KLEventDescriptionCell *descriptionCell;
@property (nonatomic, strong) KLEventPaymentCell *cellPayment;
@property (nonatomic, strong) KLEventLocationCell *cellLocation;
@property (nonatomic, strong) KLEventGalleryCell *cellGallery;

@end



@implementation KLEventViewController

@dynamic header;

- (instancetype)initWithEvent:(KLEvent *)event
{
    if (self = [super init]) {
        self.event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 177.;
    
    [self layout];
}

- (void)updateFooterMetrics
{
    [self.footer layoutIfNeeded];
    CGSize headerSize = [self.footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    UIView *footer = self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    footer.viewSize = headerSize;
    self.tableView.tableFooterView = footer;
    UIView *flexibleVew = [self.footer flexibleView];
    [flexibleVew autoPinEdge:ALEdgeBottom
                      toEdge:ALEdgeBottom
                      ofView:self.view
                  withOffset:0
                    relation:NSLayoutRelationLessThanOrEqual];
}

- (SFDataSource *)buildDataSource
{
    KLStaticDataSource *dataSource = [[KLStaticDataSource alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"EventDetailsPageCell" bundle:nil];
    self.detailsCell = [nib instantiateWithOwner:nil
                             options:nil].firstObject;
    [dataSource addItem:self.detailsCell];
    
    nib = [UINib nibWithNibName:@"EventDescriptionCell" bundle:nil];
    self.descriptionCell = [nib instantiateWithOwner:nil
                                         options:nil].firstObject;
    [dataSource addItem:self.descriptionCell];
    
    
    nib = [UINib nibWithNibName:@"KLEventPaymentCell" bundle:nil];
    self.cellPayment = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellPayment.delegate = self;
    [dataSource addItem:self.cellPayment];
    
    
    nib = [UINib nibWithNibName:@"KLEventLocationCell" bundle:nil];
    self.cellLocation = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellLocation.delegate = self;
    [dataSource addItem:self.cellLocation];
    
    
    nib = [UINib nibWithNibName:@"KLEventGalleryCell" bundle:nil];
    self.cellGallery = [nib instantiateWithOwner:nil
                                             options:nil].firstObject;
    self.cellGallery.delegate = self;
    [dataSource addItem:self.cellGallery];
    
    return dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroundHidden:YES
                                          animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBackgroundHidden:NO
                                          animated:animated];
}

- (KLEventHeaderView *)buildHeader
{
    UINib *nib = [UINib nibWithNibName:@"EventHeader" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (KLEventFooterView *)buildFooter
{
    UINib *nib = [UINib nibWithNibName:@"EventFooterView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)updateInfo
{
//    [self.header updateWithUser:self.user];
//    self.navBarTitle.text = self.user.fullName;
    [self updateFooterMetrics];
    [super updateInfo];
}

- (void)layout
{
    self.footer = [self buildFooter];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    [footer addSubview:self.footer];
    self.tableView.tableFooterView = footer;
    [UIView autoSetIdentifier:@"Footer Pins to superview" forConstraints:^{
        [self.footer autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.footer autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.footer autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.footer autoSetDimension:ALDimensionWidth toSize:self.view.width];
    }];
    [super layout];
}

#pragma mark - Cells KLeventPageCellDelegate

- (void)locationCellDidPress
{
    NSLog(@"1");
}

- (void)galleryCellDidPress:(id)image
{
    NSLog(@"2");
}

- (void)galleryCellAddImageDidPress
{
    NSLog(@"3");
}

- (void)paypentCellDidPressFree
{
    NSLog(@"4");
}

#pragma mark - UITableViewDelegate methods

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha
{
    [super updateNavigationBarWithAlpha:alpha];
    self.navBarTitle.textColor = [UIColor colorWithWhite:0.
                                                   alpha:alpha];
}

@end
