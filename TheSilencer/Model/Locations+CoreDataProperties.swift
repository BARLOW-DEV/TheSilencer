//
//  Locations+CoreDataProperties.swift
//  TheSilencer
//
//  Created by Aaron Barlow on 4/12/21.
//  Copyright © 2021 Aaron Barlow. All rights reserved.
//
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?

}
