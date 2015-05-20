//
//  KLEventPaymentInfoPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentInfoPageCell.h"
#import "KLPaymentCardCollectionViewCell.h"
#import "KLPaymentNumberAmountView.h"
#import "KLPaymentPriceAmountView.h"



@implementation KLEventPaymentInfoPageCell

- (void)setType:(KLEventPaymentInfoPageCellType)type
{
    _buy = type == KLEventPaymentInfoPageCellTypeBuy;
    if (type == KLEventPaymentInfoPageCellTypeBuy)
    {
        _color = [UIColor colorFromHex:0x2c62b4];
        self.contentView.backgroundColor = _color;
        [_buttonClose setImage:[UIImage imageNamed:@"ic_close_buy_ticket"] forState:(UIControlStateNormal)];
        _labelCardNumber.textColor = [UIColor colorFromHex:0x588fe1];
        
        [_viewPriceAmount removeFromSuperview];
        _viewPriceAmount = nil;
        
        if (!_viewNumberAmount) {
            _viewNumberAmount = [KLPaymentNumberAmountView paymentNumberAmountView];
            [_viewInputContent addSubview:_viewNumberAmount];
            [_viewNumberAmount autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
    }
    else
    {
        _color = [UIColor colorFromHex:0x0388a6];
        self.contentView.backgroundColor = _color;
        [_buttonClose setImage:[UIImage imageNamed:@"ic_close_throw_in"] forState:(UIControlStateNormal)];
        _labelCardNumber.textColor = [UIColor colorFromHex:0x15badd];
        
        [_viewNumberAmount removeFromSuperview];
        _viewNumberAmount = nil;
        
        if (!_viewPriceAmount) {
            _viewPriceAmount = [KLPaymentPriceAmountView priceAmountView];
            [_viewInputContent addSubview:_viewPriceAmount];
            [_viewPriceAmount autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            _viewPriceAmount.minimum = [NSDecimalNumber decimalNumberWithString:@"0"];
        }
        
    }

}

- (void)awakeFromNib
{
    _colletctionLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 85);
    [_collectionCards registerNib:[UINib nibWithNibName:@"KLPaymentCardCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLPaymentCardCollectionViewCell"];

    [self setOneCard];
}

- (void)setOneCard
{
    _collectionCards.hidden = YES;
    _pages.hidden = YES;
    _labelCardNumber.hidden = NO;
    _constraintCellH.constant = 139+2;
}

- (void)setMultipleCards
{
    _collectionCards.hidden = NO;
    _pages.hidden = NO;
    _labelCardNumber.hidden = YES;
    _constraintCellH.constant = 228+2;
    
    _pages.numberOfPages = 3;
}

- (IBAction)onClose:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(paymentInfoCellDidPressClose)]) {
        [self.delegate performSelector:@selector(paymentInfoCellDidPressClose) withObject:nil];
    }
}

- (void)setThrowIn
{
    [self setType:(KLEventPaymentInfoPageCellTypeThrow)];
}

- (void)setBuy
{
    [self setType:(KLEventPaymentInfoPageCellTypeBuy)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    return payments.cards.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pages.currentPage = 0.5 + scrollView.contentOffset.x / _colletctionLayout.itemSize.width;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLPaymentCardCollectionViewCell *cell = [_collectionCards dequeueReusableCellWithReuseIdentifier:@"KLPaymentCardCollectionViewCell" forIndexPath:indexPath];
    if (_buy)
        [cell setBuy];
    else
        [cell setThrowIn];
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    [cell buildWithCard:[payments.cards objectAtIndex:indexPath.row]];
    return cell;
}

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    _pages.numberOfPages = payments.cards.count;
    if (payments.cards.count > 1) {
        [self setMultipleCards];
    }
    else {
        [self setOneCard];
//        _labelCardNumber.text = @"";
    }
    
}


@end
