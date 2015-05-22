//
//  KLActivityPhotoGroupCell.m
//  Klike
//
//  Created by Alexey on 5/22/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLActivityPhotoGroupCell.h"

@interface KLActivityPhotoGroupCell ()

@property (strong, nonatomic) IBOutletCollection(PFImageView) NSArray *photoImageViews;

@end

@implementation KLActivityPhotoGroupCell

- (void)awakeFromNib
{
    
}

- (void)configureWithActivity:(KLActivity *)activity
{
    [super configureWithActivity:activity];
    
    NSInteger limit = MIN(activity.photos.count, 6);
    for (PFImageView *imageView in self.photoImageViews) {
        if (imageView.tag<limit) {
            imageView.hidden = NO;
            imageView.file = activity.photos[imageView.tag];
            [imageView loadInBackground];
        } else {
            imageView.hidden = YES;
        }
    }
}

+ (NSString *)reuseIdentifier
{
    return @"ActivityPhotoGroup";
}

@end
