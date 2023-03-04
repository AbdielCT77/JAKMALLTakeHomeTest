//
//  DetailJokeViewObject.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import Foundation

struct DetailJokeViewObject {
    var jokes: [Joke]? = []
    
    init(jokes: [Joke]? = nil) {
        self.jokes = jokes
    }
}
