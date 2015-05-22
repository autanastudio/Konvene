//
//  KLExploreTopUserTableViewCell.m
//  Klike
//
//  Created by Anton Katekov on 19.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLExploreTopUserView.h"

@implementation KLExploreTopUserViewCollectionViewCell

- (void)awakeFromNib
{
    
}

- (void)buildWithEvent:(KLEvent *)event
{
    if (event.backImage) {
        _image.file = event.backImage;
        [_image loadInBackground];
    }else {
        _image.image = [UIImage imageNamed:@"event_pic_placeholder"];
    }
}

@end

@interface KLExploreTopUserView ()

@property (nonatomic, strong) KLUserWrapper *user;
@property (nonatomic, strong) NSArray *events;

@end

@implementation KLExploreTopUserView

+ (KLExploreTopUserView*)createTopUserView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KLExploreTopUserView" owner:nil options:nil] objectAtIndex:0];
}

- (void)buildWithUser:(KLUserWrapper *)user
{
    self.user = user;
    
    self.events = [NSArray array];
    __weak typeof(self) weakSelf = self;
    PFQuery *query = [[KLEventManager sharedManager] getCreatedEventsQueryForUser:self.user];
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.events = objects;
            [_collection reloadData];
        }
    }];
    
    _imageAvatar.image = [UIImage imageNamed:@"profile_pic_placeholder"];
    _imageAvatar.file = user.userImage;
    [_imageAvatar loadInBackground];
    _labelName.text = user.fullName;
    
    NSString *folloewrsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.followers.count];
    _labelFollowersNumber.text = folloewrsCountString;
    _labelFollowersText.text = SFLocalized(@"userlist.followers.count");
    NSString *eventsCountString = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.createdEvents.count];
    _labelEventsNumber.text = eventsCountString;
    _labelEventsText.text = SFLocalized(@"userlist.events.count");
    
    if ([[KLAccountManager sharedManager] isFollowing:user]) {
        [_buttonFollow setImage:[UIImage imageNamed:@"ic_following"]
                           forState:UIControlStateNormal];
        [_buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_small_filled"]
                                     forState:UIControlStateNormal];
        [_buttonFollow setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [_buttonFollow setTitle:SFLocalized(@"userlist.following.button")
                           forState:UIControlStateNormal];
    } else {
        [_buttonFollow setImage:nil
                           forState:UIControlStateNormal];
        [_buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_small_stroke"]
                                     forState:UIControlStateNormal];
        [_buttonFollow setTitleColor:[UIColor colorFromHex:0x6466ca]
                                forState:UIControlStateNormal];
        [_buttonFollow setTitle:SFLocalized(@"userlist.follow.button")
                           forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [_collection registerNib:[UINib nibWithNibName:@"KLExploreTopUserViewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell"];
    [_imageAvatar kl_fromRectToCircle];
}

- (IBAction)onFollow:(id)sender
{
    _buttonFollow.enabled = NO;
    BOOL follow = ![[KLAccountManager sharedManager] isFollowing:self.user];
    __weak typeof(self) weakSelf = self;
    [[KLAccountManager sharedManager] follow:follow
                                        user:self.user
                            withCompletition:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    [weakSelf buildWithUser:weakSelf.user];
                                    _buttonFollow.enabled = YES;
                                }
                            }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KLExploreTopUserViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KLExploreTopUserViewCollectionViewCell" forIndexPath:indexPath];
    [cell buildWithEvent:self.events[indexPath.row]];
    
    return cell;
}


@end
