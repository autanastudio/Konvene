//
//  KLEventPaymentInfoPageCell.m
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPaymentInfoPageCell.h"
#import "KLPaymentCardCollectionViewCell.h"



@implementation KLEventPaymentInfoPageCell

- (void)setType:(KLEventPaymentInfoPageCellType)type
{
    if (type == KLEventPaymentInfoPageCellTypeBuy)
    {
        _color = [UIColor colorFromHex:0x2c62b4];
        self.contentView.backgroundColor = _color;
        [_buttonClose setImage:[UIImage imageNamed:@"ic_close_buy_ticket"] forState:(UIControlStateNormal)];
        _labelCardNumber.textColor = [UIColor colorFromHex:0x588fe1];
    }
    else
    {
        _color = [UIColor colorFromHex:0x0388a6];
        self.contentView.backgroundColor = _color;
        [_buttonClose setImage:[UIImage imageNamed:@"ic_close_throw_in"] forState:(UIControlStateNormal)];
        _labelCardNumber.textColor = [UIColor colorFromHex:0x15badd];
        
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
    _constraintCellH.constant = 139;
}

- (void)setMultipleCards
{
    _collectionCards.hidden = YES;
    _pages.hidden = YES;
    _labelCardNumber.hidden = YES;
    _constraintCellH.constant = 228;
    
    _pages.numberOfPages = 3;
}

- (IBAction)onClose:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(paymentInfoCellDidPressClose)]) {
        [self.delegate performSelector:@selector(paymentInfoCellDidPressClose) withObject:nil];
    }
}

- (void)setThrowIn
{}

- (void)setBuy
{}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pages.currentPage = 0.5 + scrollView.contentOffset.x/_colletctionLayout.itemSize.width;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLPaymentCardCollectionViewCell *cell = [_collectionCards dequeueReusableCellWithReuseIdentifier:@"KLPaymentCardCollectionViewCell" forIndexPath:indexPath];
    return cell;
}


@end
