//
//  KLSettingsRemoveCell.h
//  Klike
//
//  Created by Katekov Anton on 21.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLFormCell.h"



@protocol KLSettingsRemoveViewDelegate <NSObject>

- (void)settingsRemoveViewDidPressLogout;
- (void)settingsRemoveViewDidPressDelete;

@end



@interface KLSettingsRemoveView : UIView {
    IBOutlet UIButton *_buttonLogout;
    IBOutlet UIButton *_buttonDelete;
}

@property (nonatomic, weak) id<KLSettingsRemoveViewDelegate> delegate;

@end
