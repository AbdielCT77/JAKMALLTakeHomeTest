//
//  JokeCategoriesViewObject.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation

struct JokeCategoriesViewObject {
    var categories: [String]? = []
    var categoryAliases: [CategoryAlias]? = []
    
    init(categories: [String]? = nil, categoryAliases: [CategoryAlias]? = nil) {
        self.categories = categories
        self.categoryAliases = categoryAliases
    }
}
