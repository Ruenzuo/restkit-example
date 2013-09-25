//
//  SearchViewController.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/25/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "SearchViewController.h"
#import "City.h"
#import "CityViewController.h"

@interface SearchViewController ()
{
    NSMutableArray *_filteredDataSource;
}

- (void)setupSearchDisplayController;
- (void)filterContentForSearchText:(NSString*)searchText;

@end

@implementation SearchViewController
{
}

#pragma mark - View Controller Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSearchDisplayController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CitySegue"]) {
        CityViewController *viewController = (CityViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        City *city = [_filteredDataSource objectAtIndex:selectedIndexPath.row];
        viewController.city = city;
    }
}

#pragma mark - Lazy Loading Pattern

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    _filteredDataSource = [NSMutableArray arrayWithCapacity:[_dataSource count]];
}

#pragma mark - Private Methods

- (void)setupSearchDisplayController
{
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

-(void)filterContentForSearchText:(NSString*)searchText
{
	[_filteredDataSource removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    [_filteredDataSource addObjectsFromArray:[_dataSource filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredDataSource count];
    }
    else {
        return [_dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
    City *city = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        city = [_filteredDataSource objectAtIndex:indexPath.row];
    }
    else {
        city = [_dataSource objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Lat: %.2f, Lon: %.2f",[city.latitude floatValue],[city.longitude floatValue]];
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
