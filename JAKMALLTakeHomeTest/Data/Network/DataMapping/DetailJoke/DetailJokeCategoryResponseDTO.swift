//
//  DetailJokeCategoryResponseDTO.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import Foundation

// MARK: - DetailJokeResponseDTO
struct DetailJokeResponseDTO: Codable {
    var error: Bool?
    var amount: Int?
    var jokes: [Joke]?
    var joke: String?
    
}

// MARK: - Joke
struct Joke: Codable {
    var category, type, joke: String?
    var flags: Flags?
    var id: Int?
    var safe: Bool?
    var lang: String?

}

// MARK: - Flags
struct Flags: Codable {
    var nsfw, religious, political, racist: Bool?
    var sexist, explicit: Bool?
}

extension DetailJokeResponseDTO {
    mutating func toDomain() -> DetailJokeViewObject {
        if let joke = joke {
            var arrayJokes = [Joke]()
            arrayJokes.append(Joke(joke: joke))
            return .init(jokes: arrayJokes)
        }
        return .init(jokes: jokes)
    }
}
