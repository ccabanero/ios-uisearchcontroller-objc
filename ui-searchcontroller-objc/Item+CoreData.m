//
//  Item+CoreData.m
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/26/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import "Item+CoreData.h"

@implementation Item (CoreData)

+ (void)insertItemDataFromPlist:(NSString *)plistFileName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
    
    NSArray *items =  [[NSArray alloc] initWithContentsOfFile:filePath];

    for(NSDictionary *currentItem in items) {
        
        [Item insertItemWithDictionary:currentItem inManagedObjectContext:managedObjectContext];
    }
}

+ (void)insertItemWithDictionary:(NSDictionary *)itemDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    //prepare fetch request for item name
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [itemDictionary objectForKey:@"name"]];
    
    //execute fetch
    NSError *fetchError = nil;
    
    Item *item = nil;
    
    item = [[managedObjectContext executeFetchRequest:request error:&fetchError] lastObject];
    
    if(!fetchError) {
        
        //create if the item doesn't exist - if exists then properties are updated
        if(item == nil) {
            
            item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
        }
        
        item.name = [itemDictionary objectForKey:@"name"];
        
        item.group = [itemDictionary objectForKey:@"group"];
        
        //save
        NSError *saveError = nil;
        
        [managedObjectContext save:&saveError];
    }
}

+ (NSArray *)fetchItemsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSArray *results = [[NSArray alloc] init];
    
    
    //prepare fetch request for items
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    
    
    //execute fetch request
    NSError *error = nil;
    
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    
    if(items) {
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
        
        results = [items sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    return results;
}

+ (NSArray *)fetchDistinctItemGroupsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSArray *results = [[NSArray alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    
    [request setResultType:NSDictionaryResultType];
    
    [request setReturnsDistinctResults:YES];
    
    [request setPropertiesToFetch:@[@"group"]];
    
    NSError *error = nil;
    
    //note, an array of NSDictionaries is returned where the key is the property name (e.g. group) and the value is the letter
    NSArray *items = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:items.count];
    
    for(NSDictionary *currentDictionary in items) {
        
        [mutableArray addObject:[currentDictionary objectForKey:@"group"]];
    }
    
    results = [NSArray arrayWithArray:mutableArray];
    
    return results;
}

+ (NSArray *)fetchItemNamesBeginningWith:(NSString *)searchText inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSArray *results = [[NSArray alloc] init];
    
    //prepare fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", searchText];
    
    //execute fetch request
    NSArray *items =  [managedObjectContext executeFetchRequest:request error:nil];
    
    //serialize to an array of name string objects
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:items.count];
    
    for(Item *currentItem in items) {
        
        //add the item name
        [names addObject:currentItem.name];
    }
    
    //serialize to non-mutable
    results = [NSArray arrayWithArray: names];
    
    return results;
}

+ (NSArray *)fetchItemNamesByGroupInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSArray *results = [[NSArray alloc] init];
    
    
    //groups
    NSArray *itemGroups = [Item fetchDistinctItemGroupsInManagedObjectContext:managedObjectContext];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:itemGroups.count];
    
    for(NSString *group in itemGroups) {
        
        //items in group
        NSArray *groupItems = [Item fetchItemNamesBeginningWith:group inManagedObjectContext:managedObjectContext];
        
        
        //create item and group structure
        NSDictionary *itemAndGroup = [[NSDictionary alloc] initWithObjectsAndKeys:groupItems, group, nil];
        
        [mutableArray addObject:itemAndGroup];
    }
    
    //serialize to non-mutable
    results = [NSArray arrayWithArray:mutableArray];

    return results;
}

+ (NSDictionary *)fetchItemNamesByGroupFilteredBySearchText:(NSString *)searchText inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSDictionary *result = nil;
    
    //to be used as the key for the returned NSDictionary
    NSString *firstLetterOfSearchText = [[searchText substringToIndex:1] uppercaseString];
    
    NSArray *itemNames = [Item fetchItemNamesBeginningWith:searchText inManagedObjectContext:managedObjectContext];
    
    result = [[NSDictionary alloc] initWithObjectsAndKeys:itemNames, firstLetterOfSearchText, nil];
    
    return result;
}

@end
