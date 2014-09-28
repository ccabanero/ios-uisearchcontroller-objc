//
//  Item.h
//  ui-searchcontroller-objc
//
//  Created by Clint Cabanero on 9/27/14.
//  Copyright (c) 2014 Big Leaf Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * name;

@end
