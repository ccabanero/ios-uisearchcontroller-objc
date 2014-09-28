//
//  TableViewControllerTest.m
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/26/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TableViewController.h"
#import "AppDelegate.h"

@interface TableViewControllerTest : XCTestCase

//for accessing CoreData NSManagedObjectContext in assertions
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

//system under test
@property (nonatomic, strong) TableViewController *viewControllerUnderTest;

@end


@implementation TableViewControllerTest

- (void)setUp {
    
    [super setUp];
    
    
    //for accessing CoreData NSManagedObjectContext
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    
    
    //get story board
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    //get target view controller from story board
    self.viewControllerUnderTest = (TableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    
    
    //pass the managed object context
    self.viewControllerUnderTest.managedObjectContext = self.managedObjectContext;
    
    
    //load the view hierarchy
    [self.viewControllerUnderTest performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    [self.viewControllerUnderTest performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    
    //for accessing CoreData NSManagedObjectContext
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appDelegate managedObjectContext];
}

- (void)tearDown {
    
    self.viewControllerUnderTest = nil;
    
    self.managedObjectContext = nil;
    
    self.appDelegate = nil;
    
    [super tearDown];
}

- (void)testViewContorllerUnderTestInstantiation {
    
    XCTAssertNotNil(self.viewControllerUnderTest, @"ViewController under test fails to instantiate");
}

- (void)testViewControllerUnderTestFetchesDistinctGroupsForTableViewSections {
    
    XCTAssertNotNil(self.viewControllerUnderTest.tableSections, @"ViewController under test fails to load with the tableSections property set");
}

- (void)testViewControllerUnderTestFetchesTableSectionsAndItems {
    
    XCTAssertNotNil(self.viewControllerUnderTest.tableSectionsAndItems, @"ViewController under test fails to load with tableSectionsAndItems property set");
}

- (void)testViewControllerConformsToTableViewDataSourceProtocol {
    
    XCTAssertTrue([self.viewControllerUnderTest conformsToProtocol:@protocol(UITableViewDataSource)], @"ViewController under test does not conform to the UITableViewDataSource prototocol");
    
    XCTAssertTrue([self.viewControllerUnderTest respondsToSelector:@selector(numberOfSectionsInTableView:)], @"ViewController under test does not implement numberOfSectionsInTableView protocol method");
    
    XCTAssertTrue([self.viewControllerUnderTest respondsToSelector:@selector(tableView:numberOfRowsInSection:)], @"ViewController under test does not implement tableView:numberOfRowsInSection protocol method");
    
    XCTAssertTrue([self.viewControllerUnderTest respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)], @"ViewController under test does not implement tableView:cellForRowAtIndexPath");
    
    //continue with other UITableViewDataSource protocol methods of interest ...
}

- (void)testViewControllerConformsToTableViewDelegateProtocol {
    
    XCTAssertTrue([self.viewControllerUnderTest conformsToProtocol:@protocol(UITableViewDelegate)], @"ViewController under test does not conform to the UITableViewDelegate protocol.");
    
    XCTAssertTrue([self.viewControllerUnderTest respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)], @"ViewController under test does not implement tableView:didSelectRowAtIndexPath: protocol method");
    
    //continue with other UITableViewDelegate protocol methods of interest ...
}

- (void)testTableViewCellsHaveCorrectTextLabel {
    
    NSIndexPath *rowIndex0 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell0 = [self.viewControllerUnderTest tableView:self.viewControllerUnderTest.tableView cellForRowAtIndexPath:rowIndex0];
    
    XCTAssert([cell0.textLabel.text isEqualToString:@"Admiral Ackbar"], @"ViewController under test is composed of a UITableView that has improperly initialized UITableViewCells");
    
    
    NSIndexPath *rowIndex1 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    UITableViewCell *cell1 = [self.viewControllerUnderTest tableView:self.viewControllerUnderTest.tableView cellForRowAtIndexPath:rowIndex1];
    
    XCTAssert([cell1.textLabel.text isEqualToString:@"Anakin Skywalker"], @"ViewController under test is composed of a UITableView that has improperly initialized UITableViewCells");
}

- (void)testTableFilteredWhenUserEntersTextInSearchBar {
    
    //simulate a user searching for 'J'
    self.viewControllerUnderTest.searchController.searchBar.text = @"J";
    
    [self.viewControllerUnderTest updateSearchResultsForSearchController:self.viewControllerUnderTest.searchController];
    
    
    //searching in search bar changes the state of the tableSectionsAndItems property of the ViewController under test (for rendering table items)
    NSIndexPath *rowIndex0 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell0 = [self.viewControllerUnderTest tableView:self.viewControllerUnderTest.tableView cellForRowAtIndexPath:rowIndex0];
    
    NSString *expectedCellTextLabel = @"Jabba the Hutt";
    
    NSString *actualCellTextLabel = cell0.textLabel.text;
    
    XCTAssertEqualObjects(expectedCellTextLabel, actualCellTextLabel, @"ViewController under test is composed of UITableView that fails to filter when searched for 'J'");
}

@end
