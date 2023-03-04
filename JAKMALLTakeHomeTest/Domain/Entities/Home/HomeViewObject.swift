//
//  HomeViewObject.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import Foundation

struct HomeViewObject {
    var category: String
    var detail: [Joke]
    var isOpen: Bool
    var disableAddData: Int
    
    init(category: String = "",
         detail: [Joke] = [],
         isOpen: Bool = false,
         disableAddData: Int = 0
    ) {
        self.category = category
        self.detail = detail
        self.isOpen = isOpen
        self.disableAddData = disableAddData
    }
}
