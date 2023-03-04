//
//  NetworkService.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 02/03/23.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

protocol NetworkService {
    func request(
        _ url: URL,
        _ method: HTTPMethod,
        _ parameters: Parameters?
    ) -> Observable<(Data?, HTTPURLResponse?)>
}

final class DefaultNetworkService : NetworkService{
    
    func request(
        _ url: URL,
        _ method: HTTPMethod,
        _ parameters: Parameters? = nil
    ) -> Observable<(Data?, HTTPURLResponse?)> {
        
        return Observable.create { emitter in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil,
                interceptor: nil,
                requestModifier: nil
            ).response { response in
                switch response.result {
                case .success(_) :
                    let httpCode = response.response?.statusCode ?? 0
                    if response.data != nil
                        && (httpCode >= 200 && httpCode <= 299) {
                        emitter.onNext((response.data , response.response))
                    }
                    else {
                        let errorCustom = BaseError.httpError(httpCode)
                        emitter.onError(errorCustom)
                    }
                case .failure(let error) :
                    let errorCustom = BaseError.httpError(error.responseCode ?? 0)
                    emitter.onError(errorCustom)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
        .map(errorFilter(_:))
    }
    
    private func errorFilter(
        _ transform: ((Data?, HTTPURLResponse?))
    ) throws -> (Data?, HTTPURLResponse?) {
        let (data, response) = transform
        
        let json = JSON(data as Any)
        
        
        if let isError = json["error"].bool {
            if isError {
                let results = json["message"].stringValue
                let errorCode = json["code"].intValue
                
                throw BaseError.custom(
                    code: String(errorCode), title: "API FAIlURE", desc: results
                )
            }else{
                return transform
            }
        }else{
            throw BaseError.httpError(response?.statusCode ?? 0)
        }
    }
}
