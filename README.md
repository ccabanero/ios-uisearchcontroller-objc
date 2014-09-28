ios-uisearchcontroller
======================

####Description

With __iOS 8__, UISearchDisplayController is now __deprecated__.  This repo provides sample code for one way to approach searching/filtering a sectioned UITableView using the new __UISearchController__ introduced with __iOS 8__.

Resembling the __user interface__ of the Contacts app, the provided sample code implements the following features:

* Displaying data in a __UITableView__ with __Sections__.
* Data is persisted as NSManagedObject subclasses using __Core Data__.
* A __Section Index__ allows the user to quickly move through the table items with a swipe gesture.
* Finally, the __iOS 8 UISearchController__ is used to present a __Search Bar__ that allows the user to __search__ and __filter__ the items presented in the UITableView.
	
Wait, wuh? Here are some screen shots ...
![screenshot](https://s3-us-west-1.amazonaws.com/app-static-assets/images/filtertable.png)

####Language
Objective-C

####User Interface Idiom
This version of the solution uses Storyboards to layout the view hierarchy.

####Unit Testing Framework
Unit tests are provided to demonstrate ways to assert behavior and state of Model classes and Controller classes in this sample.  Uses the XCTest.framework.

####Contact
* Twitter: [@clintcabanero](http://twitter.com/clintcabanero)
* GitHub: [ccabanero](http:///github.com/ccabanero)
