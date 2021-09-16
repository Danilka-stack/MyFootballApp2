//
//  FMatch+CoreDataProperties.swift
//  
//
//  Created by Daniil Reshetnyak on 24.06.2021.
//
//

import Foundation
import CoreData

extension FMatch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FMatch> {
        return NSFetchRequest<FMatch>(entityName: "FMatch")
    }

    @NSManaged public var competitionName: String?
    @NSManaged public var date: String?
    @NSManaged public var side1: String?
    @NSManaged public var side2: String?
    @NSManaged public var title: String?
    @NSManaged public var videosURL: String?
  
}
