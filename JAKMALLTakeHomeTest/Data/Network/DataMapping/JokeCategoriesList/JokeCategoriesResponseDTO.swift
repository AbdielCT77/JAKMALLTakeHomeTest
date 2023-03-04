//
//  JokeCategoriesResponseDTO.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation

// MARK: - JokeCategoriesResponseDTO
struct JokeCategoriesResponseDTO: Codable {
    let error: Bool?
    let categories: [String]?
    let categoryAliases: [CategoryAlias]?
    let timestamp: Int?
}

// MARK: - CategoryAlias
struct CategoryAlias: Codable {
    let alias, resolved: String?
}


extension JokeCategoriesResponseDTO {
    func toDomain() -> JokeCategoriesViewObject {
        return .init(
            categories: categories,
            categoryAliases: categoryAliases
        )
    }
}
