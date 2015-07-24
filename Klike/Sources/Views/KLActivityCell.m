//
//  KLActivityCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityCell.h"

NSString *klUserObjectTag = @"klUserObjectTag";

@implementation KLActivityUserCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self.userImageView autoSetDimensionsToSize:CGSizeMake(32., 32.)];
        [self.userImageView kl_fromRectToCircle];
        [self.contentView addSubview:self.userImageView];
        [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.userImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

- (void)configureWithuser:(KLUserWrapper *)user
{
    if (user.userImageThumbnail) {
        self.userImageView.file = user.userImageThumbnail;
        [self.userImageView loadInBackground];
    } else {
        self.userImageView.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    }
}

@end

@implementation KLActivityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithActivity:(KLActivity *)activity
{
    self.activity = activity;
    self.timeLabel.text = [NSString stringTimeSinceDate:activity.updatedAt];
}

+ (NSString *)reuseIdentifier
{
    return @"";
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length) {
        NSRange range;
        KLUserWrapper *user = [textView.textStorage attribute:klUserObjectTag
                                                      atIndex:characterIndex
                                               effectiveRange:&range];
        if (user && self.delegate && [self.delegate respondsToSelector:@selector(activityCell:showUserProfile:)]) {
            [self.delegate activityCell:self
                        showUserProfile:user];
        }
        
    }
}

@end
