//
//  MyStarBooksTableViewController.m
//  Bookcase
//
//  Created by Ching-Hua Hung on 15/7/21.
//
//

#import "MyStarBooksTableViewController.h"
#import "MyStarBooks.h"
#import "BookDetailTableViewController.h"

extern NSString *const MyStarBooksDidUpdateNotification;

@interface MyStarBooksTableViewController ()

@property(nonatomic, strong) NSArray *myStarBooks;

@end

@implementation MyStarBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:MyStarBooksDidUpdateNotification
                                               object:nil];
}

- (void)reloadData {
    self.myStarBooks = [MyStarBooks all];
    if ([_myStarBooks count]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_myStarBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyStarBookCell"];
    cell.textLabel.text = _myStarBooks[indexPath.row][@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MyStarBooks removeBook:_myStarBooks[indexPath.row][@"isbn"]];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BookDetailTableViewController *bookDetailTVC = [segue destinationViewController];
    bookDetailTVC.url = _myStarBooks[self.tableView.indexPathForSelectedRow.row][@"url"];
}

@end
