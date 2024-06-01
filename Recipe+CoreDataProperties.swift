//
//  Recipe+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/31/24.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var recipeIndex: Int16
    @NSManaged public var recipeID: Int64
    @NSManaged public var recipeName: String?
    @NSManaged public var recipeWay: String?
    @NSManaged public var recipeType: String?
    @NSManaged public var ingredient: String?
    @NSManaged public var recipeCal: String?
    @NSManaged public var infoCar: String?
    @NSManaged public var infoPro: String?
    @NSManaged public var infoFat: String?
    @NSManaged public var infoNa: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var manualSet: [String]
    @NSManaged public var manualImgSet: [String]

}

extension Recipe : Identifiable {

}

