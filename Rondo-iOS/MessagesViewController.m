//
//  MessagesViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/26/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "MessagesViewController.h"
#import <Leanplum/Leanplum.h>

@interface MessagesViewController ()

@property (nonatomic, strong) NSArray <NSString *>* options;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Messages";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.title = @"Message Templates";
    self.options = @[
                @"alert",
                @"centerPopup",
                @"confirm",
                @"interstitial",
                @"webInterstitial",
                @"richInterstitial",
                @"starRating",
                @"banner",
                ];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.options[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Leanplum track:self.options[indexPath.row]];
}

@end
