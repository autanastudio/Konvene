//
//  KLCreatorCell.m
//  Klike
//
//  Created by Alexey on 5/8/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCreatorCell.h"

@implementation KLCreatorCell

- (IBAction)onUser:(id)sender
{
    [self.delegate creatorCellDelegateDidPress];
}

@end
