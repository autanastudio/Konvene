//
//  KLGalleryObject.m
//  Klike
//
//  Created by Alexey on 7/23/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLGalleryObject.h"

static NSString *klGalleryObjectClassName = @"GalleryObject";

@implementation KLGalleryObject

@dynamic photo;
@dynamic owner;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return klGalleryObjectClassName;
}

@end
