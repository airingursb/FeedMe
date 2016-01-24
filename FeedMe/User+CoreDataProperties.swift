//
//  User+CoreDataProperties.swift
//  FeedMe
//
//  Created by Airing on 16/1/24.
//  Copyright © 2016年 Airing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var age: NSNumber?

}
