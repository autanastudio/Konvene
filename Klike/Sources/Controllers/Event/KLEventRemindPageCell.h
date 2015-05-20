//
//  KLEventRemindPageCell.h
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"

@interface KLEventRemindPageCell : KLEventPageCell {
    
    IBOutlet UIImageView *_imageSavingBG;
    IBOutlet UILabel *_labeSave;
    IBOutlet UIImageView *_imageStar;
    IBOutlet UIImageView *_imageSeparator;
    IBOutlet UIButton *_saveButton;
}

- (void)setSaved:(BOOL)saved;

@end
