//
//  LeanplumEnvPickerTableViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumEnvPickerTableViewController.h"
#import "LeanplumEnvCreateViewController.h"
#import "LeanplumEnvPersistence.h"
#import "RondoState.h"
#import "RondoPreferences.h"

@interface LeanplumEnvPickerTableViewController ()

@property (nonatomic, strong) NSArray <LeanplumEnv *> *items;

@end

@implementation LeanplumEnvPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Env Picker";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New Env" style:UIBarButtonItemStylePlain target:self action:@selector(addItem)];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.items = [LeanplumEnvPersistence loadLeanplumEnvs];
    [self.tableView reloadData];
}

-(void)addItem {
    LeanplumEnvCreateViewController *vc = [[LeanplumEnvCreateViewController alloc] initWithNibName:@"LeanplumEnvCreateViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = self.items[indexPath.row].apiHostName;
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeanplumEnv *env = self.items[indexPath.row];
    RondoState *state = [RondoState sharedState];
    state.env = env;
    [RondoPreferences updateWithEnv:env];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
