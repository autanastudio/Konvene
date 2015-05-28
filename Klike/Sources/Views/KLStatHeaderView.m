//
//  KLStatHeaderView.m
//  Klike
//
//  Created by Alexey on 5/27/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLStatHeaderView.h"
#import <UICountingLabel/UICountingLabel.h>

static CGFloat klInfoHeight = 25.;

@interface KLStatGroup : NSObject

@property (nonatomic, assign) KLEventPricingType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UICountingLabel *countLabel;

@end

@implementation KLStatGroup

@end

@interface KLStatHeaderView () <KLParalaxView>

@property (weak, nonatomic) IBOutlet UICountingLabel *amountLabel1;
@property (weak, nonatomic) IBOutlet UICountingLabel *amountLabel2;
@property (weak, nonatomic) IBOutlet UICountingLabel *amountLabel3;

@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;
@property (weak, nonatomic) IBOutlet UILabel *descLabel3;

@property (weak, nonatomic) IBOutlet UIView *statContainer;
@property (nonatomic, strong) NSArray *nonEmptyGroup;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;


@property (weak, nonatomic) IBOutlet UIView *flexibleView;

@end

@implementation KLStatHeaderView

- (void)configureWithEvnet:(KLEvent *)event
{
    if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
        self.descLabel1.text = @"per ticket";
        self.descLabel2.text = @"you get";
        self.descLabel3.text = @"sold";
        
        NSInteger soldTickets = [event.price.soldTickets integerValue];
        self.amountLabel1.text = [NSString stringWithFormat:@"$%ld", (long)[event.price.pricePerPerson integerValue]];
        self.amountLabel2.text = [NSString stringWithFormat:@"$%d", soldTickets*[event.price.pricePerPerson integerValue]];
        self.amountLabel3.text = [NSString stringWithFormat:@"%ld", (long)soldTickets];
    } else {
        self.descLabel1.text = @"gathered";
        self.descLabel2.text = @"you get";
        self.descLabel3.text = @"threw in";
        
        NSInteger gathered = [event.price.throwIn integerValue];
        self.amountLabel1.text = [NSString stringWithFormat:@"$%ld", (long)gathered];
        self.amountLabel2.text = [NSString stringWithFormat:@"$%ld", (long)gathered];
        self.amountLabel3.text = [NSString stringWithFormat:@"%lu", (unsigned long)event.price.payments.count];
    }
    if (event.price.payments.count) {
        self.placeholderView.hidden = YES;
        UIColor *lineColor;
        UIColor *categoryNameColor;
        NSArray *groupAmount;
        NSArray *groupTitles;
        if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
            lineColor = [UIColor colorFromHex:0x599bff];
            categoryNameColor = [UIColor colorFromHex:0x2c5ca3];
            groupAmount = @[@2, @3, @4, @0];
            groupTitles = @[@"1", @"2", @"3" ,@"4"];
        } else {
            lineColor = [UIColor colorFromHex:0x00d0ff];
            categoryNameColor = [UIColor colorFromHex:0x00738c];
            groupAmount = @[@1, @5, @10, @20, @0];
            groupTitles = @[@"$0", @"$1-5", @"$6-10" ,@"$11-20", @">$20"];
        }
        NSMutableDictionary *groups = [NSMutableDictionary dictionary];
        for (int i=0; i<groupAmount.count; i++) {
            KLStatGroup *newGroup = [[KLStatGroup alloc] init];
            newGroup.type = [event.eventType integerValue];
            newGroup.title = groupTitles[i];
            newGroup.count = 0;
            [groups setObject:newGroup forKey:groupAmount[i]];
        }
        
        for (KLCharge *charge in event.price.payments) {
            if(![charge isEqual:[NSNull null]]) {
                NSInteger amount = 0;
                if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
                    amount = [charge.amount integerValue]/[event.price.pricePerPerson integerValue];
                } else {
                    amount = [charge.amount integerValue];
                }
                for (NSNumber *condition in groupAmount) {
                    if (amount < [condition integerValue] || [condition integerValue] == 0) {
                        KLStatGroup *group = [groups objectForKey:condition];
                        group.count += 1;
                        break;
                    }
                }
            }
        }
        
        NSInteger maxCount = 0;
        NSMutableArray *nonEmptyGroup = [NSMutableArray array];
        for (NSNumber *condition in groupAmount) {
            KLStatGroup *group = groups[condition];
            if (group.count > 0) {
                [nonEmptyGroup addObject:group];
                if (group.count>maxCount) {
                    maxCount = group.count;
                }
            }
        }
        self.nonEmptyGroup = nonEmptyGroup;
        
        CGSize containerSize = self.statContainer.bounds.size;
        CGFloat weightCount = (containerSize.height - klInfoHeight*2)/(CGFloat)maxCount;
        CGFloat lineWidth = containerSize.width/(CGFloat)nonEmptyGroup.count;
        UIView *lastLine;
        CGFloat brightnessStep = 25./(CGFloat)nonEmptyGroup.count;
        
        for (int i=0; i<nonEmptyGroup.count; i++) {
            KLStatGroup *currentGroup = nonEmptyGroup[i];
            UIColor *currentColor = [self color:lineColor withBrightnessStep:-25.+brightnessStep*i];
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = currentColor;
            [self.statContainer addSubview:line];
            [line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.];
            if (!lastLine) {
                [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.];
            } else {
                [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastLine withOffset:0.];
            }
            [line autoSetDimension:ALDimensionWidth toSize:lineWidth];
            currentGroup.height = klInfoHeight + weightCount*currentGroup.count;
            currentGroup.heightConstraint = [line autoSetDimension:ALDimensionHeight toSize:klInfoHeight];
            lastLine = line;
            //Create title for line
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
            titleLabel.textColor = categoryNameColor;
            titleLabel.text = currentGroup.title;
            [self.statContainer addSubview:titleLabel];
            if ([event.price.pricingType integerValue] == KLEventPricingTypePayed) {
                UIImageView *ticketIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_ticket-1"]];
                ticketIcon.tintColor = categoryNameColor;
                [self.statContainer addSubview:ticketIcon];
                [ticketIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:line withOffset:8.];
                [ticketIcon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.];
                [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:6.];
                [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:ticketIcon withOffset:5.];
            } else {
                [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:line withOffset:8.];
                [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:6.];
            }
            //Create counter for line
            currentGroup.countLabel = [[UICountingLabel alloc] init];
            currentGroup.countLabel.font = [UIFont helveticaNeue:SFFontStyleMedium size:14.];
            currentGroup.countLabel.textColor = currentColor;
            currentGroup.countLabel.format = @"%d";
            currentGroup.countLabel.text = @"0";
            [self.statContainer addSubview:currentGroup.countLabel];
            UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_user_stats"]];
            userIcon.tintColor = currentColor;
            [self.statContainer addSubview:userIcon];
            [userIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:line withOffset:8.];
            [userIcon autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line withOffset:-7.];
            [currentGroup.countLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line withOffset:-7.];
            [currentGroup.countLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userIcon withOffset:5.];
        }
        [lastLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.];
    } else {
        self.placeholderView.hidden = NO;
    }
}

- (void)startAnimation
{
    NSTimeInterval delay = 0;
    for (KLStatGroup *group in self.nonEmptyGroup) {
        [self performSelector:@selector(animateGroup:) withObject:group afterDelay:delay];
        delay += 0.1;
    }
}

- (void)animateGroup:(KLStatGroup *)group
{
    [group.countLabel countFromZeroTo:group.count withDuration:0.2];
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        group.heightConstraint.constant = group.height;
        [self.statContainer layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (UIColor *)color:(UIColor *)color withBrightnessStep:(CGFloat)step
{
    CGFloat hue, saturation, brightness, alpha ;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ];
    brightness += step/255.;
    UIColor *newColor = [ UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha ];
    return newColor;
}

- (UIView *)buildLine
{
    UIView *view = [[UIView alloc] init];
    return view;
}

@end
