//
//  Item+CoreData.h
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/26/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import "Item.h"

@interface Item (CoreData)

/*!
 * @description For seeding CoreData with data in plist file.
 * @param plistFileName Name of plist file in app bundle.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return void
 */
+ (void)insertItemDataFromPlist:(NSString *)plistFileName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For inserting an Item entity into CoreData.
 * @param itemDictionary NSDictionary of key value pairs for each Item entity.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return void
 */
+ (void)insertItemWithDictionary:(NSDictionary *)itemDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For fetching all item entities from CoreData.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return NSArray of Item entity objects.
 */
+ (NSArray *)fetchItemsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For fetching a collection of distinct 'group' attributes across all instances of the Item entity
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return NSArray of Item entity objects.
 */
+ (NSArray *)fetchDistinctItemGroupsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For fetching a NSArray of Item names beginning with the passed in search text.
 * @param searchText The search text used to filter the returned item names.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return NSArray of string objects representing item names.
 */
+ (NSArray *)fetchItemNamesBeginningWith:(NSString *)searchText inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For fetching a collection of NSDictionaries where the key is the Group and the value is a collection of Item Names.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return NSArray of NSDictionaries.
 */
+ (NSArray *)fetchItemNamesByGroupInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/*!
 * @description For returning a NSDictionary where the key is the first letter of the input searchText and the value is a NSArray of items string objects that begin with the input searchText.
 * @param managedObjectContext The CoreData NSManagedObjectContext.
 * @return NSDictionary
 */
+ (NSDictionary *)fetchItemNamesByGroupFilteredBySearchText:(NSString *)searchText inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
