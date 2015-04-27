//
//  KLLocationCell.m
//  Klike
//
//  Created by admin on 23/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLLocationCell.h"
#import "KLLocation.h"

@interface KLLocationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorLeftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorLeftConstraint;
@end

static CGFloat klSeparatorLeftMargin = 16.;

@implementation KLLocationCell

- (void)configureWithVenue:(KLLocation *)venue
                      type:(KLLocationcellType)type
{
    if (venue) {
        if ([venue.custom boolValue]) {
            self.topSeparator.hidden = NO;
            self.currentLocationIcon.hidden = NO;
            self.currentLocationLabel.hidden = NO;
            self.locationTitle.hidden = YES;
            self.bottomSeparatorLeftConstraint.constant = 0;
        } else {
            self.topSeparator.hidden = YES;
            self.currentLocationIcon.hidden = YES;
            self.currentLocationLabel.hidden = YES;
            self.locationTitle.hidden = NO;
            self.bottomSeparatorLeftConstraint.constant = klSeparatorLeftMargin;
            if (type == KLLocationcellTypeCity) {
                self.locationTitle.text = venue.description;
            } else {
                self.locationTitle.text = venue.description;
            }
        }
    }
}

@end
