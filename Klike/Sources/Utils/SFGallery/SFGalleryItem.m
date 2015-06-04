//
//  SFGalleryItem.m
//  Livid
//
//  Created by Sibagatov Ildar on 24.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import "SFGalleryItem.h"

@implementation SFGalleryItem

+ (instancetype)itemWithImage:(UIImage*)image
{
    SFGalleryItem *item = [[self alloc] initWithURL:nil
                                       thumbnailURL:nil
                                           itemType:SFGalleryItemTypeImage];

    item.image = image;
    return item;
}

+ (instancetype)itemWithVideoURL:(NSURL *)videoURL thumbnailURL:(NSURL *)thumbnailURL
{
    return [[self alloc] initWithURL:videoURL
                        thumbnailURL:thumbnailURL
                            itemType:SFGalleryItemTypeVideo];
}

+ (instancetype)itemWithImageURL:(NSURL *)imageURL thumbnailURL:(NSURL *)thumbnailURL
{
    return [[self alloc] initWithURL:imageURL
                        thumbnailURL:thumbnailURL
                            itemType:SFGalleryItemTypeImage];
}

- (instancetype)initWithURL:(NSURL *)URL
               thumbnailURL:(NSURL *)thumbnailURL
                   itemType:(SFGalleryItemType)type
{
    self = [super init];
    if (self) {
        _URL = URL;
        _thumbnailURL = thumbnailURL;
        _type = type;
    }
    return self;
}

@end
