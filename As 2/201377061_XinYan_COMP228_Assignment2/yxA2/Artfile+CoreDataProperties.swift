//
//  Artfile+CoreDataProperties.swift
//  yxA2
//
//  Created by 刘钊汐 on 2019/5/7.
//  Copyright © 2019 xin.yan. All rights reserved.
//
//

import Foundation
import CoreData


extension Artfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artfile> {
        return NSFetchRequest<Artfile>(entityName: "Artfile")
    }

    @NSManaged public var artist: String?
    @NSManaged public var fileName: String?
    @NSManaged public var id: String?
    @NSManaged public var information: String?
    @NSManaged public var lastModified: String?
    @NSManaged public var lat: String?
    @NSManaged public var long: String?
    @NSManaged public var location: String?
    @NSManaged public var locationNotes: String?
    @NSManaged public var title: String?
    @NSManaged public var yearOfWork: String?

}
