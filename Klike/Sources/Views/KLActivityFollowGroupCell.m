//
//  KLActivityFollowGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityFollowGroupCell.h"

static CGFloat klUserImageWidth = 24.;
static CGFloat klUserImageTraling = 8.;

@interface KLActivityFollowGroupCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageViewTrailing;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectonView;

@end

@implementation KLActivityFollowGroupCell

- (void)awakeFromNib
{
    [self.userImageView kl_fromRectToCircle];
    [self.collectonView registerClass:[KLActivityUserCollectionCell class]
           forCellWithReuseIdentifier:klUserCollectionCellReuseId];
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
    UIFont *descriptionFont = [UIFont helveticaNeue:SFFontStyleRegular size:12.];
    UIColor *grayColor = [UIColor colorFromHex:0xb3b3bd];
    UIColor *purpleColor = [UIColor colorFromHex:0x6466ca];
    
    if ([self.activity.activityType integerValue] == KLActivityTypeFollowMe) {
        NSString *descritpionStr = [NSString stringWithFormat:@"%lu users started following you", (unsigned long)self.activity.users.count];
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:descritpionStr
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[description]];
        
        self.userImageViewWith.constant = 0;
        self.userImageViewTrailing.constant = 0;
        
    } else if([self.activity.activityType integerValue] == KLActivityTypeFollow){
        KLUserWrapper *from  = [[KLUserWrapper alloc] initWithUserObject:self.activity.from];
        if (from.userImageThumbnail) {
            self.userImageView.file = from.userImageThumbnail;
            [self.userImageView loadInBackground];
        } else {
            self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
        }
        KLAttributedStringPart *fromStr = [[KLAttributedStringPart alloc] initWithString:from.fullName
                                                                                   color:purpleColor
                                                                                    font:descriptionFont];
        KLAttributedStringPart *description = [[KLAttributedStringPart alloc] initWithString:@" started following "
                                                                                       color:grayColor
                                                                                        font:descriptionFont];
        self.descriptionLabel.attributedText = [KLAttributedStringHelper stringWithParts:@[fromStr, description]];
        
        self.userImageViewWith.constant = klUserImageWidth;
        self.userImageViewTrailing.constant = klUserImageTraling;
    }
    
    [self.collectonView reloadData];
}

+ (NSString *)reuseIdentifier
{
    return @"ActivityFollowGroup";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.activity.users.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLActivityUserCollectionCell *cell = [self.collectonView dequeueReusableCellWithReuseIdentifier:klUserCollectionCellReuseId forIndexPath:indexPath];
    if (indexPath.row<self.activity.users.count) {
        KLUserWrapper *user  = [[KLUserWrapper alloc] initWithUserObject:self.activity.users[indexPath.row]];
        if (user) {
            [cell configureWithuser:user];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLUserWrapper *user  = [[KLUserWrapper alloc] initWithUserObject:self.activity.users[indexPath.row]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityCell:showUserProfile:)]) {
        [self.delegate activityCell:self
                    showUserProfile:user];
    }
}

@end
