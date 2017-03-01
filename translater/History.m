//
//  History.m
//  translater
//
//  Created by Tony Hrabovskyi on 2/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "Translator.h"
#import "HistoryCell.h"
#import "History.h"


@interface History () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
// UI elements
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyMessageLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
// controls
@property (strong, nonatomic) Translator *translator;
@property (strong, nonatomic) NSArray *searchResult;

@end

@implementation History

static NSString *historyCellIdentifier = @"HistoryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.translator = [Translator sharedInstance];
    self.searchResult = self.translator.history;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self filterContentForSearch:self.searchBar.text];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {   // called when text changes (including clear)
    [self filterContentForSearch:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar { // called when keyboard search button pressed
    //[self filterContentForSearch:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar { // called when cancel button pressed
    [self.searchBar resignFirstResponder];
}


#pragma mark - SearchController

- (void)filterContentForSearch:(NSString *)searchText {
    
    if ([searchText rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound) {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(outputText CONTAINS[cd] %@) OR (inputText CONTAINS[cd] %@)", searchText, searchText];
        self.searchResult = [self.translator.history filteredArrayUsingPredicate:searchPredicate];
    } else {
        self.searchResult = self.translator.history;
    }
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)clearHistoryAction:(id)sender {
    
    [self.translator clearHistory];
    self.searchResult = self.translator.history;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = FALSE;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier];
    
    [historyCell showHistory:[self.searchResult objectAtIndex:indexPath.row]];
    
    return historyCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TranslateEntity *translateEntity = [self.searchResult objectAtIndex:indexPath.row];
        translateEntity.isFavorite = FALSE;
        [self.translator.history removeObject:translateEntity];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = self.searchResult.count;
    [self.emptyMessageLabel setHidden:(rowCount > 0)];
    return rowCount;
}



@end