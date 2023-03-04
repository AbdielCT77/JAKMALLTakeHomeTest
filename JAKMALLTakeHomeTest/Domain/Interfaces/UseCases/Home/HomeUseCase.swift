//
//  HomeUseCase.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func executeFetchJokeCategoriesList() -> Observable<JokeCategoriesViewObject>
    func executeFetchJokeDetail(category: String, amount: String) -> Observable<DetailJokeViewObject>
}
