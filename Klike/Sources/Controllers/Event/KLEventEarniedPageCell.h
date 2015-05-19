//
//  KLEventEarniedPageCell.h
//  Klike
//
//  Created by Katekov Anton on 13.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventPageCell.h"



typedef NS_ENUM(NSUInteger, KLEventEarniedPageCellType) {
    KLEventEarniedPageCellPayd,
    KLEventEarniedPageCellThrow,
};



@interface KLEventEarniedPageCell : KLEventPageCell {
    
    IBOutlet UILabel *_labelTop1;
    IBOutlet UILabel *_labelTop2;
    IBOutlet UILabel *_labelTop3;
    IBOutlet UILabel *_labelBottom1;
    IBOutlet UILabel *_labelBottom2;
    IBOutlet UILabel *_labelBottom3;
    
}

- (void)setType:(KLEventEarniedPageCellType)type;

@end
