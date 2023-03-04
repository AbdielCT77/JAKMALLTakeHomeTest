//
//  DefaultHomeUseCase.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import RxSwift

final class DefaultHomeUseCase: HomeUseCase {
    private let homeRepository: HomeRepository
    
    init() {
        self.homeRepository = DefaultHomeRepository()
    }
    
    func executeFetchJokeCategoriesList() -> Observable<JokeCategoriesViewObject> {
        return homeRepository.fetchJokesList()
    }
    
    func executeFetchJokeDetail(
        category: String,
        amount: String
    ) -> Observable<DetailJokeViewObject> {
        return homeRepository.fetchJokesDetailList(
            category: category, amount: amount
        )
    }
}
