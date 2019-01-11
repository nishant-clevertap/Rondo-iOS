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
#import "AppInboxTableViewCell.h"

@interface AppInboxTableViewController ()

@property (strong, nonatomic) LPInbox *inbox;
@property (assign, nonatomic) int tagOffset;

@end

@implementation AppInboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Inbox";
    self.tagOffset = 666;
    self.inbox = [Leanplum inbox];
    [self.tableView reloadData];

    [self.tableView registerNib:[UINib nibWithNibName:@"AppInboxTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inbox.allMessages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LPInboxMessage *message = self.inbox.allMessages[indexPath.row];

    NSData *data = [NSData dataWithContentsOfURL:message.imageURL];
    UIImage *img = [[UIImage alloc] initWithData:data];

    cell.title.text = message.title;
    cell.subtitle.text = message.subtitle;
    cell.image.image = img;
    cell.button.tag = self.tagOffset + indexPath.row;
    [cell.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(void)buttonPressed:(UIButton *)sender {
    int row = (int)(sender.tag - self.tagOffset);
    LPInboxMessage *message = self.inbox.allMessages[row];
    [message read];
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 334.;
}

@end
