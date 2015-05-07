//
//  KLCheatManager.m
//  Klike
//
//  Created by admin on 31/03/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLCheatManager.h"

static NSString *klCheckUsersFromContactsKey = @"checkUsersFromContacts";

@implementation KLCheatManager

+ (KLCheatManager *)sharedManager {
    static KLCheatManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)followFirstTenUsers
{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i = 0;
        for (PFUser *user in objects) {
            KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:user];
            [[KLAccountManager sharedManager] follow:YES
                                                user:userWrapper
                                    withCompletition:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            NSLog(@"Follow user with name successfully %@", userWrapper.fullName);
                                        } else {
                                            NSLog(@"Follow failed with error %@", error.localizedDescription);
                                        }
                                    }];
            if (++i==10) {
                return;
            }
        }
    }];
}

- (void)inviteFirstTenUsersToEvent
{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i = 0;
        for (PFUser *user in objects) {
            KLUserWrapper *userWrapper = [[KLUserWrapper alloc] initWithUserObject:user];
            KLEvent *event = [KLEvent eventWithoutDataWithId:[KLAccountManager sharedManager].currentUser.createdEvents[0]];
            [[KLEventManager sharedManager] inviteUser:userWrapper
                                               toEvent:event
                                          completition:^(id object, NSError *error) {
                if (!error) {
                    NSLog(@"Invite user %@ successfully", userWrapper.fullName);
                } else {
                    NSLog(@"Invite failed with error %@", error.localizedDescription);
                }
            }];
            if (++i==10) {
                return;
            }
        }
    }];
}

- (void)checkCloudFunction
{
    NSArray *testArray = @[@"+79999999989", @"+79999999990", @"+79999999994", @"+17048169059"];
    [PFCloud callFunctionInBackground:klCheckUsersFromContactsKey
                       withParameters:@{ @"phonesArray" : testArray}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Succes test cloud function!");
                                    } else {
                                        NSLog(@"Failure test cloud function!");
                                    }
                                }];
}

@end
