//
//  User+CoreDataProperties.swift
//  FeedMe
//
//  Created by Airing on 16/2/4.
//  Copyright © 2016年 Airing. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userId: NSNumber?
    @NSManaged var userName: String?
    @NSManaged var userBirthday: String?
    @NSManaged var userSex: NSNumber?
    @NSManaged var userAccount: String?
    @NSManaged var userHead: String?
    @NSManaged var userCreateTime: String?
    @NSManaged var userPoint: NSNumber?
    @NSManaged var userPersonality: String?

}
