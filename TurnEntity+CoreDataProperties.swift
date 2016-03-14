//
//  TurnEntity+CoreDataProperties.swift
//  PushUpUsedCoreData
//
//  Created by Student on 3/14/16.
//  Copyright © 2016 Student. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TurnEntity {

    @NSManaged var data: NSDate?
    @NSManaged var countPushUp: NSNumber?

}
