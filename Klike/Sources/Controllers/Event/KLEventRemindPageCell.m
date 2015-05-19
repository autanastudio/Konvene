//
//  KLEventRemindPageCell.m
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventRemindPageCell.h"

@implementation KLEventRemindPageCell

- (void)configureWithEvent:(KLEvent *)event
{
    [super configureWithEvent:event];
    
    [self setSaved:NO];
    
}

- (void)setSaved:(BOOL)saved
{
    if (saved) {
        _imageSavingBG.hidden = NO;
        _labeSave.textColor = [UIColor whiteColor];
        _imageSeparator.hidden = YES;
        _imageStar.image = [UIImage imageNamed:@"reminderStarWhite"];
    }
    else {
        _imageSavingBG.hidden = YES;
        _labeSave.textColor = [UIColor colorFromHex:0x6466ca];
        _imageSeparator.hidden = NO;
        _imageStar.image = [UIImage imageNamed:@"reminderStar"];
        
    }
}

- (IBAction)onSave:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(reminderCellDidSavePress)]) {
        [self.delegate performSelector:@selector(reminderCellDidSavePress) withObject:nil];
    }
}

- (IBAction)onRemind:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(reminderCellDidRemindPress)]) {
        [self.delegate performSelector:@selector(reminderCellDidRemindPress) withObject:nil];
    }
}

@end
