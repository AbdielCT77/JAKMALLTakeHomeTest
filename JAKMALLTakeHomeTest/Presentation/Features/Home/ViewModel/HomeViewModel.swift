//
//  HomeViewModel.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import Foundation
import RxSwift
import RxCocoa

extension HomeViewModel: ViewModelType {
    struct Input {
        let fetchJokeCategories: Driver<Void>
        let fetchDetailJoke: Driver<(category: String, amount: String)>
        let refreshJokes: Driver<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let error: Driver<Error>
        let successFetchJokeCategories: Driver<[HomeViewObject]>
        let successFetchDetailJoke: Driver<DetailJokeViewObject>
        let successRefreshJokes: Driver<[HomeViewObject]>
    }
}

final class HomeViewModel: ObservableObject {
    private let homeUseCase: HomeUseCase
    let activityTracker = ActivityTracker()
    let errorTracker = ErrorTracker()

    
    init() {
        self.homeUseCase = DefaultHomeUseCase()
    }
    
}

extension HomeViewModel {
    func transform(input: Input) -> Output {
        let fetchJokeCategories = input.fetchJokeCategories
            .flatMapLatest { _ in
                return self.homeUseCase
                    .executeFetchJokeCategoriesList()
                    .trackActivity(self.activityTracker)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .map { viewObject -> [HomeViewObject] in
                guard let categories = viewObject.categories else { return [] }
                var value = [HomeViewObject]()
                for category in categories {
                    value.append(
                        HomeViewObject(category: category)
                    )
                }
                return value
            }
        
        let fetchDetailJoke = input.fetchDetailJoke
            .flatMapLatest { result in
                return self.homeUseCase
                    .executeFetchJokeDetail(
                        category: result.category, amount: result.amount
                    )
                    .trackActivity(self.activityTracker)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let refreshJokes =  input.refreshJokes
            .flatMapLatest { _ in
                return self.homeUseCase
                    .executeFetchJokeCategoriesList()
                    .trackActivity(self.activityTracker)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .map { viewObject -> [HomeViewObject] in
                guard let categories = viewObject.categories else { return [] }
                var value = [HomeViewObject]()
                for category in categories {
                    value.append(
                        HomeViewObject(category: category)
                    )
                }
                return value
            }
        
        
        
        return Output(
            loading: self.activityTracker.asDriver(),
            error: self.errorTracker.asDriver(),
            successFetchJokeCategories: fetchJokeCategories,
            successFetchDetailJoke: fetchDetailJoke,
            successRefreshJokes: refreshJokes
        )
    }
}
