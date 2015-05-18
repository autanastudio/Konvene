//
//  KLTicketViewController.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLPhotoViewer.h"



@interface KLTicketViewController : KLPhotoViewer {
    
    IBOutlet UIView *_viewTop;
    IBOutlet UIView *_viewBottom;
    IBOutlet UIImageView *_image;
}

@property (nonatomic)UIImage *eventImage;

@end
