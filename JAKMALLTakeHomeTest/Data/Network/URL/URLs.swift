//
//  URLs.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation

struct URLs {
    private static let BaseUrl = "https://v2.jokeapi.dev/"
    
    static let categoryJokesUrl = BaseUrl + "categories"
    static let detailCategoryJokesUrl = BaseUrl + "joke/"
    static let detailCaregoryJokesKeyUrl = "?type=single&amount="
}
