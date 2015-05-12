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
