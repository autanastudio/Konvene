//
//  KLTicketViewController.h
//  Klike
//
//  Created by Anton Katekov on 14.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLEntities.h"
#import "KLPhotoViewer.h"



@interface KLTicketViewController : KLPhotoViewer {
    
    IBOutlet UIView *_viewTop;
    IBOutlet UIView *_viewBottom;
    IBOutlet UIImageView *_image;
    IBOutlet UILabel *_labelTicketNumber;
    IBOutlet UILabel *_labeCost;
    IBOutlet UILabel *_labelEventName;
    IBOutlet UIImageView *_imageClock;
    IBOutlet UILabel *_labelTime;
    IBOutlet UIImageView *_imagePin;
    IBOutlet UILabel *_labelDistance;
}

@property (nonatomic)UIImage *eventImage;
@property (nonatomic)KLEvent *event;

@end
