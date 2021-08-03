//
//  PlaceCD+CoreDataProperties.swift
//  My Favorite Place
//
//  Created by Xin.Yan on 2019/5/10.
//  Copyright © 2019 Yan Xin. All rights reserved.
//
//

import Foundation
import CoreData


extension PlaceCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceCD> {
        return NSFetchRequest<PlaceCD>(entityName: "PlaceCD")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var location: String?

}
