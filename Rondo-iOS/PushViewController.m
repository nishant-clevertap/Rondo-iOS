//
//  PushViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/26/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "PushViewController.h"
#import <Leanplum/Leanplum.h>

@interface PushViewController ()

@property (nonatomic, strong) NSArray <NSString *>* options;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Push";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.title = @"Message Templates";
    self.options = @[
                     @"pushRender",
                     @"pushAction",
                     @"pushImage",
                     @"pushExistingAction",
                     @"pushURL",
                     @"pushOptions",
                     @"pushLocal",
                     @"pushLocalCancel",
                     @"pushMuted",
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Leanplum track:self.options[indexPath.row]];
}

@end
