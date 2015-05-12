//
//  KLReminderViewController.h
//  Klike
//
//  Created by Anton Katekov on 08.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"

@interface KLReminderViewController : KLViewController {
    IBOutlet UITableView *_table; 
}

@property KLEvent *event;

@end
