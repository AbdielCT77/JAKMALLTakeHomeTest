//
//  HomeRepository.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import RxSwift

protocol HomeRepository {
    func fetchJokesList() -> Observable<JokeCategoriesViewObject>
    func fetchJokesDetailList(category: String, amount: String) -> Observable<DetailJokeViewObject>
}
