//
//  Item+CoreDataTest.m
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/26/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "Item.h"
#import "Item+CoreData.h" //note: Item+CoreData is a category for the Item entity (i.e. NSManagedObject subclass)

@interface Item_CoreDataTest : XCTestCase

//for accessing CoreData NSManagedObjectContext in assertions
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation Item_CoreDataTest

- (void)setUp {
    
    [super setUp];
    
    //for accessing CoreData NSManagedObjectContext
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    
    
    //execute class method for seeding CoreData with Item entities (i.e. NSManagedObject subclass instances)
    [Item insertItemDataFromPlist:@"ItemSeed" inManagedObjectContext:self.managedObjectContext];
}

- (void)tearDown {
    
    self.managedObjectContext = nil;
    
    self.appDelegate = nil;
    
    [super tearDown];
}

- (void)testModelClassSeededCoreData {
    
    NSArray *itemsInCoreData = [Item fetchItemsInManagedObjectContext:self.managedObjectContext];
    
    XCTAssertNotNil(itemsInCoreData, @"Model under test fails to seed CoreData with Item entities");
    
    XCTAssert([itemsInCoreData count] > 0, @"Model under test fails to seed CoreData with Item entities");
}

- (void)testModelClassSeededCoreDataWithItemsProperlyAttributed {
    
    NSArray *itemsInCoreData = [Item fetchItemsInManagedObjectContext:self.managedObjectContext];
    
    Item *sampleItem = [itemsInCoreData lastObject];
    
    XCTAssert([sampleItem isKindOfClass:[Item class]], @"Model under test seeded CoreData, but entity is not of type Item");
    
    XCTAssert([sampleItem.name length] > 0, @"Model under test seeded CoreData, but entity does not have a name property assigned");
}

- (void)testModelClassFetchesDistinctGroupProperties {
    
    NSArray *distinctGroups = [Item fetchDistinctItemGroupsInManagedObjectContext:self.managedObjectContext];
    
    XCTAssertNotNil(distinctGroups, @"Model under test does not fetch distinct group proeperties between all Item instances");
    
    //count the number of distinctGroups fetched from CoreData
    NSUInteger actualCount = [distinctGroups count];
    
    //serialize to a NSSet to ensure we get unique values
    NSSet *set = [NSSet setWithArray:distinctGroups];
    
    NSUInteger expectedCount = [set count];
    
    XCTAssertEqual(expectedCount, actualCount, @"Model under test does not proplery fetch distinct groups");
}

- (void)testModelClassFetchesItemNamesBySearchText {
    
    NSString *searchText = @"Y";
    
    NSString *expectedResultName = @"Yoda";
    
    NSArray *searchResults = [Item fetchItemNamesBeginningWith:searchText inManagedObjectContext:self.managedObjectContext];

    BOOL expectedResultNameIsFetched = NO;
    
    for(NSString *currentSearchResult in searchResults) {
        
        if([currentSearchResult isEqualToString:expectedResultName]) {
            
            expectedResultNameIsFetched = YES;
        }
    }
    
    XCTAssertTrue(expectedResultNameIsFetched, @"Model under test fails to fetch names beginning with a search text");
}

- (void)testModelClassFetchesItemNamesByGroup {
    
    //confirm expected structure
    NSArray *itemsAndGroups = [Item fetchItemNamesByGroupInManagedObjectContext:self.managedObjectContext];
    
    XCTAssertNotNil(itemsAndGroups, @"Model under test does not fetch items and groups");
    
    XCTAssert([itemsAndGroups isKindOfClass:[NSArray class]], @"Model under test does not fetch items and groups as a NSArray");
    
    NSDictionary *sampleDict = [itemsAndGroups lastObject];
    
    XCTAssert([sampleDict isKindOfClass:[NSDictionary class]], @"Model under test does not fetch items and groups as a NSArray of NSDictionary types");
    
    XCTAssert([[sampleDict objectForKey:@"Y"] isKindOfClass:[NSArray class]], @"Model under test fails to fetch items and groups as a NSArray of NSDictionaies where the key 'Y' and the value is an NSArray");
    
    NSArray *collectionOfNames = [sampleDict objectForKey:@"Y"];
    
    XCTAssert([[collectionOfNames lastObject] isKindOfClass:[NSString class]], @"Model under test fails to fetch items and groups as a NSArray of NSDictionaries where the key is a letter (e.g. 'Y') and the value is an NSArray of String objects");
}


- (void)testModelClassCanFetchSectionAndItemsWithSearchText {
    
    NSString *searchText = @"Y";
    
    NSString *expectedItemName = @"Yoda";
    
    NSDictionary *sectionsAndItems = [Item fetchItemNamesByGroupFilteredBySearchText:searchText inManagedObjectContext:self.managedObjectContext];
    
    XCTAssertNotNil(sectionsAndItems, @"Model under test fails to create a NSDictionary of items by group with supplied search text");
    
    XCTAssertEqualObjects([[sectionsAndItems objectForKey:searchText] lastObject], expectedItemName, @"Model under test fails to create a NSDictionary with correct values of Item name objects using the supplied search text");
}

@end
