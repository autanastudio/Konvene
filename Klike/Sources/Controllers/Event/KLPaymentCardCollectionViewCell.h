//
//  KLPaymentCardCollectionViewCell.h
//  Klike
//
//  Created by Anton Katekov on 15.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KLCard;



@interface KLPaymentCardCollectionViewCell : UICollectionViewCell {
    
    IBOutlet UILabel *_labelName;
    IBOutlet UILabel *_labelNumber;
    IBOutlet UIImageView *_imageCardBackground;
}

- (void)setThrowIn;
- (void)setBuy;
- (void)buildWithCard:(KLCard*)card;

@end
