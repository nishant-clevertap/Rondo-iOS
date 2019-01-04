//
//  LeanplumAppPickerTableViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 1/4/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumAppPickerTableViewController.h"
#import "LeanplumAppPersistence.h"
#import "RondoState.h"
#import "RondoPreferences.h"

@interface LeanplumAppPickerTableViewController ()

@property (nonatomic, strong) NSArray <LeanplumApp *> *items;

@end

@implementation LeanplumAppPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Picker";

    self.items = [LeanplumAppPersistence loadLeanplumApps];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
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
    cell.textLabel.text = self.items[indexPath.row].displayName;
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LeanplumApp *app = self.items[indexPath.row];
    RondoState *state = [RondoState sharedState];
    state.app = app;
    [RondoPreferences updateWithApp:app];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
