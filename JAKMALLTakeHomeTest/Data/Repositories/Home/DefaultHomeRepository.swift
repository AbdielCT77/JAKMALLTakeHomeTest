//
//  DefaultHomeRepository.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import RxSwift


final class DefaultHomeRepository{
    private let apiClient: NetworkService
    
    init() {
        self.apiClient = DefaultNetworkService()
    }
}

extension DefaultHomeRepository: HomeRepository {
    func fetchJokesList() -> Observable<JokeCategoriesViewObject> {
        let url = URL(string: URLs.categoryJokesUrl)!
        return apiClient.request(
            url,
            .get,
            nil
        ).map { data, response in
            if let data = data {
                do {
                    let jokeList = try JSONDecoder().decode(
                        JokeCategoriesResponseDTO.self,
                        from: data
                    )
                    return jokeList.toDomain()
                }
            }
            else { return JokeCategoriesViewObject() }
        }
    }
    
    func fetchJokesDetailList(
        category: String,
        amount: String
    ) -> Observable<DetailJokeViewObject> {
       let url = URL(
            string: URLs.detailCategoryJokesUrl +
            category +
            URLs.detailCaregoryJokesKeyUrl + amount
        )!
        return apiClient.request(
            url,
            .get,
            nil
        ).map { data, response in
            if let data = data {
                do {
                    var detailJoke = try JSONDecoder().decode(
                        DetailJokeResponseDTO.self,
                        from: data
                    )
                    return detailJoke.toDomain()
                }
            }
            else { return DetailJokeViewObject() }
        }
    }
    
    
}
