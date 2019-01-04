//
//  AppInboxTableViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AppInboxTableViewController.h"
#import <Leanplum/Leanplum.h>
#import <Leanplum/LPInbox.h>

@interface AppInboxTableViewController ()

@property (strong, nonatomic) LPInbox *inbox;

@end

@implementation AppInboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Inbox";
    self.inbox = [Leanplum inbox];
    [self.tableView reloadData];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inbox.allMessages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LPInboxMessage *message = self.inbox.allMessages[indexPath.row];

    NSData *data = [NSData dataWithContentsOfURL:message.imageURL];
    UIImage *img = [[UIImage alloc] initWithData:data];

    cell.textLabel.text = message.title;
    cell.imageView.image = img;
    cell.detailTextLabel.text = message.subtitle;

    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LPInboxMessage *message = self.inbox.allMessages[indexPath.row];
    [message read];
}

@end
