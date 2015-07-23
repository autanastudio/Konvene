//
//  KLGalleryObject.h
//  Klike
//
//  Created by Alexey on 7/23/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <Parse/Parse.h>

@interface KLGalleryObject : PFObject <PFSubclassing>

@property (nonatomic, strong) PFFile *photo;
@property (nonatomic, strong) PFUser *owner;

@end
