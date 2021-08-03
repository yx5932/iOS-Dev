//
//  Items+CoreDataProperties.swift
//  Shopping List
//
//  Created by Xin.Yan on 2019/5/6.
//  Copyright © 2019 Yan Xin. All rights reserved.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var items: String?

}
