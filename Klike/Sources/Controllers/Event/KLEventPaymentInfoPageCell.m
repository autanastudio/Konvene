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
        _viewContent.backgroundColor = _color;
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
        _viewContent.backgroundColor = _color;
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
    
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    if (payments.cards.count > 0)
    {
        KLCard *card = [payments.cards objectAtIndex:0];
        if (card.isDataAvailable) {
            _labelCardNumber.text = [@"XXXX-"stringByAppendingString:card.last4];
        }
    }
}

- (void)setMultipleCards
{
    _collectionCards.hidden = NO;
    _pages.hidden = NO;
    _labelCardNumber.hidden = YES;
    _constraintCellH.constant = 228;
    
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    _pages.numberOfPages = payments.cards.count;
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
    
    _viewContent.alpha = 1;
    CALayer *layer = _viewContent.layer;
    CATransform3D transform = CATransform3DIdentity;
    layer.transform = transform;
    
    _collectionCards.alpha = 1;
    _labelCardNumber.alpha = 1;
    _buttonClose.alpha = 1;
    _pages.alpha = 1;
    [_viewNumberAmount resetAnimation];
    [_viewPriceAmount resetAnimation];
    
    
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    _pages.numberOfPages = payments.cards.count;
    if (payments.cards.count > 1) {
        [self setMultipleCards];
    }
    else {
        [self setOneCard];
    }
    if (_viewPriceAmount) {
        _viewPriceAmount.minimum = [NSDecimalNumber decimalNumberWithDecimal:event.price.minimumAmount.decimalValue];
    }
    
}


- (KLCard*)card
{
    KLUserWrapper *user = [KLAccountManager sharedManager].currentUser;
    KLUserPayment *payments = user.paymentInfo;
    if (payments.cards.count == 1) {
        return [payments.cards objectAtIndex:0];
    }
    else
        return [payments.cards objectAtIndex:_pages.currentPage];
}

- (NSNumber*)number
{
    if (_viewPriceAmount) 
        return _viewPriceAmount.number;
    else
        return @(_viewNumberAmount.number);
}

- (void)startAppearAnimation
{
    _labelCardNumber.alpha = 0;
    _pages.alpha = 0;
    _collectionCards.alpha = 0;
    _buttonClose.alpha = 0;
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(0, 10);
    _labelCardNumber.transform = t;
    _pages.transform = t;
    _collectionCards.transform = t;
    _buttonClose.transform = t;
    
    [UIView animateWithDuration:0.25
                          delay:0.20
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         
                         _labelCardNumber.alpha = 1;
                         _pages.alpha = 1;
                         _collectionCards.alpha = 1;
                         _buttonClose.alpha = 1;
                         
                         CGAffineTransform t = CGAffineTransformIdentity;
                         _labelCardNumber.transform = t;
                         _pages.transform = t;
                         _collectionCards.transform = t;
                         _buttonClose.transform = t;
                         
                     } completion:NULL];
    
    [_viewNumberAmount startAppearAnimation];
    [_viewPriceAmount startAppearAnimation];
}

- (void)startDisappearAnimation:(void (^)(void))completion
{
    
    _constraintCellH.constant = 50;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _collectionCards.alpha = 0;
                         _labelCardNumber.alpha = 0;
                         _buttonClose.alpha = 0;
                         _pages.alpha = 0;
//                         _viewContent.alpha = 0.3;
                     }
                     completion:NULL];
    
    [_viewNumberAmount startDisappearAnimation];
    [_viewPriceAmount startDisappearAnimation];
    
    [UIView animateWithDuration:0.2
                          delay:0.05
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
                         
                         CALayer *layer = _viewContent.layer;
                         CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                         rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                         rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0.5 * M_PI * 1.0, 1, 0, 0);
                         layer.transform = rotationAndPerspectiveTransform;
                         
                     }
                     completion:^(BOOL finished) {
                         completion();
                     }];

}

@end
