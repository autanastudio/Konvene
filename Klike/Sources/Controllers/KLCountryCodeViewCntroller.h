//
//  KLCountryCodeViewCntroller.h
//  Klike
//
//  Created by admin on 05/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLCountryCodeProtocol <NSObject>

- (void)dissmissCoutryCodeViewControllerWithnewCode:(NSString *)code;

@end

@interface KLCountryCodeViewCntroller : UITableViewController

@property (nonatomic, strong) id<KLCountryCodeProtocol> delegate;

@end
