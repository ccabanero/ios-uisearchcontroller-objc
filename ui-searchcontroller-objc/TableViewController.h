//
//  TableViewController.h
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/27/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *tableSections;

@property (nonatomic, strong) NSMutableArray *tableSectionsAndItems;

@end
