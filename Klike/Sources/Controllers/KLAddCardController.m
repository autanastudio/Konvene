//
//  KLAddCardController.m
//  Klike
//
//  Created by Alexey on 5/14/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLAddCardController.h"
#import "KLCreateCardView.h"
#import "KLCardScanAdapter.h"

@interface KLAddCardController () <KLCreateCardViewDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *addCardButton;
@property (nonatomic, strong) KLCreateCardView *cardView;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) KLCardScanAdapter *scanAdapter;
@end

@implementation KLAddCardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:0xf2f2f7];
    
    self.container = [[UIView alloc] init];
    self.container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.container];
    [self.container autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                             excludingEdge:ALEdgeBottom];
    
    self.cardView = [self buildCreateCardView];
    self.cardView.deleagate = self;
    
    self.addCardButton = [[UIButton alloc] init];
    [self.addCardButton setBackgroundImage:[UIImage imageNamed:@"big_btn"] forState:UIControlStateNormal];
    [self.addCardButton setBackgroundImage:[UIImage imageNamed:@"big_btn_disabled"] forState:UIControlStateDisabled];
    self.addCardButton.titleLabel.font = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
    [self.addCardButton setTitle:SFLocalized(@"settings.payment.addCard") forState:UIControlStateNormal];
    [self.addCardButton setTitleColor:[UIColor colorFromHex:0x6466ca] forState:UIControlStateNormal];
    [self.addCardButton setTitleColor:[UIColor colorFromHex:0x91919f] forState:UIControlStateDisabled];
    [self.addCardButton autoSetDimension:ALDimensionWidth toSize:290.];
    [self.addCardButton addTarget:self
                           action:@selector(onAdd)
                 forControlEvents:UIControlEventTouchUpInside];
    self.addCardButton.enabled = NO;
    
    [self.container addSubview:self.cardView];
    [self.container addSubview:self.addCardButton];
    
    [self.cardView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.addCardButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.cardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                            excludingEdge:ALEdgeBottom];
    [self.addCardButton autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                         withInset:16.];
    [self.cardView autoPinEdge:ALEdgeBottom
                        toEdge:ALEdgeTop
                        ofView:self.addCardButton
                    withOffset:-14.];
    [self.cardView configureColorsForSettings];
    
    NSString *capitalizedTitle = [SFLocalized(@"settings.payment.addCard") capitalizedString];
    [self kl_setTitle:capitalizedTitle withColor:[UIColor blackColor] spacing:nil];
    [self kl_setNavigationBarColor:[UIColor whiteColor]];
    
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(onBack)];
    self.backButton.tintColor = [UIColor colorFromHex:0x6466ca];
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scanAdapter = [[KLCardScanAdapter alloc] init];
}

- (KLCreateCardView *)buildCreateCardView
{
    UINib *nib = [UINib nibWithNibName:@"CreateCardView" bundle:nil];
    return [nib instantiateWithOwner:nil
                             options:nil].firstObject;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enableControls:(BOOL)enable
{
    self.addCardButton.enabled = enable && self.cardView.valid;
    self.cardView.enabled = enable;
}

- (void)onAdd
{
    __weak typeof(self) weakSelf = self;
    [self enableControls:NO];
    [[KLAccountManager sharedManager] addCard:self.cardView.card
                             withCompletition:^(id object, NSError *error) {
                                 if (!error) {
                                     [weakSelf onBack];
                                 } else {
                                     [weakSelf showNavbarwithErrorMessage:error.userInfo[NSLocalizedDescriptionKey]];
                                 }
                                 [weakSelf enableControls:YES];
    }];
}

#pragma mark - KLCreaCardDelegate

- (void)showScanCardControllerCardView:(KLCreateCardView *)view
{
    [self.scanAdapter showScancontrollerFromViewController:self
                                              withCardView:view];
}

- (void)showCSVInfoControllerCardView:(KLCreateCardView *)view
{
    
}

- (void)cardChangeValidCardControllerCardView:(KLCreateCardView *)view
{
    self.addCardButton.enabled = view.valid;
}

@end
