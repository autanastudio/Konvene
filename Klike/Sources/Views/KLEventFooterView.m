//
//  KLEventFooterView.m
//  Klike
//
//  Created by admin on 29/04/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLEventFooterView.h"

@interface KLEventFooterView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation KLEventFooterView

- (void)awakeFromNib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.transform = CGAffineTransformMakeScale(1., -1.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    cell.transform = CGAffineTransformMakeScale(1., -1.);
    cell.textLabel.text = [NSString stringWithFormat:@"Comment #%ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

@end
