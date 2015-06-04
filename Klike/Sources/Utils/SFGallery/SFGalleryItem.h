//
//  SFGalleryItem.h
//  Livid
//
//  Created by Sibagatov Ildar on 24.04.15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SFGalleryItemType) {
    SFGalleryItemTypeImage,
    SFGalleryItemTypeVideo,
    SFGalleryItemTypeAudio
};

@interface SFGalleryItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, assign) SFGalleryItemType type;

+ (instancetype)itemWithImage:(UIImage*)image;
+ (instancetype)itemWithImageURL:(NSURL *)imageURL thumbnailURL:(NSURL *)thumbnailURL;
+ (instancetype)itemWithVideoURL:(NSURL *)videoURL thumbnailURL:(NSURL *)thumbnailURL;

- (instancetype)initWithURL:(NSURL *)URL
               thumbnailURL:(NSURL *)thumbnailURL
                   itemType:(SFGalleryItemType)type;

@end